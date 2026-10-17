/**
 * Web Search Extension
 *
 * Uses Kagi when KAGI_API_TOKEN is configured, otherwise anonymous Parallel
 * Search MCP. PI_WEB_SEARCH_PROVIDER can select kagi, parallel, or disabled.
 */

import {
  type ExtensionAPI,
  type ExtensionContext,
  getPackageDir,
} from '@earendil-works/pi-coding-agent';
import {readFileSync} from 'node:fs';
import {findPackageJSON} from 'node:module';
import {dirname, join, resolve} from 'node:path';
import {pathToFileURL} from 'node:url';
import {type Static, Type} from 'typebox';
import {Check, Errors} from 'typebox/value';

const KAGI_SEARCH_URL = 'https://kagi.com/api/v1/search';
const PARALLEL_SEARCH_URL = 'https://search.parallel.ai/mcp';
const SEARCH_USER_AGENT =
  'wincent-web-search/1.0 (https://github.com/wincent/wincent)';

async function searchParallel(
  query: string,
  context: ExtensionContext,
  signal?: AbortSignal,
) {
  signal?.throwIfAborted();

  // Use the MCP client shipped with the managed Pi runtime. Unlike pi-ai and
  // typebox, pi-mcp is not aliased by Pi's extension loader. Resolve from Pi,
  // not this directory's type-only node_modules tree (or the project's cwd).
  const packagePath = findPackageJSON(
    '@earendil-works/pi-mcp',
    pathToFileURL(join(getPackageDir(), 'package.json')),
  );
  if (!packagePath) {
    throw new Error('The managed Pi runtime is missing pi-mcp.');
  }
  const {main} = JSON.parse(readFileSync(packagePath, 'utf8')) as {
    main: string;
  };
  const {McpClient, StreamableHttpTransport} = await import(
    pathToFileURL(resolve(dirname(packagePath), main)).href
  ) as typeof import('@earendil-works/pi-mcp');

  const timeout = AbortSignal.timeout(30_000);
  const requestSignal = signal ? AbortSignal.any([signal, timeout]) : timeout;
  const client = new McpClient({name: 'wincent-web-search', version: '1.0'});
  const transport = new StreamableHttpTransport({
    url: PARALLEL_SEARCH_URL,
    headers: {'User-Agent': SEARCH_USER_AGENT},
    openGetStream: false,
    fetch: (input, init) =>
      fetch(input, {
        ...init,
        signal: init?.signal
          ? AbortSignal.any([init.signal, requestSignal])
          : requestSignal,
      }),
  });

  try {
    await client.connect(transport);
    const result = await client.callTool('web_search', {
      objective: query,
      search_queries: [query],
      session_id: context.sessionManager.getSessionId(),
    }, {signal: requestSignal});
    const content = result.content.flatMap((block) =>
      block.type === 'text' ? [{type: 'text' as const, text: block.text}] : []
    );
    if (result.isError) {
      throw new Error(
        `Parallel search error: ${
          content.map((block) => block.text).join('\n')
        }`,
      );
    }
    if (!content.length) {
      throw new Error('Parallel search returned no text content.');
    }
    return {content, details: {provider: 'parallel', query}};
  } catch (error) {
    requestSignal.throwIfAborted();
    throw error;
  } finally {
    await client.close();
  }
}

/**
 * Kagi may send an explicit `null` (rather than omitting the key) for fields it
 * has no value for. Most commonly `snippet`, on results whose page has no
 * usable description.
 */
const NullableString = Type.Union([Type.String(), Type.Null()]);

const KagiSearchResultSchema = Type.Object({
  url: Type.Optional(NullableString),
  title: Type.Optional(NullableString),
  snippet: Type.Optional(NullableString),
  time: Type.Optional(NullableString),
  props: Type.Optional(Type.Unknown()),
});
type KagiSearchResult = Static<typeof KagiSearchResultSchema>;

type KagiSections = Record<string, KagiSearchResult[]>;

/**
 * v1 groups results into named sections rather than tagging each result with a
 * `t` discriminator. Observed sections are `search`, `video`, `related_search`
 * and `interesting_finds`, but the set is open-ended, so accept any name.
 */
const KagiResponseSchema = Type.Object({
  meta: Type.Object({
    trace: Type.String(),
    node: Type.String(),
    ms: Type.Number(),
  }),
  data: Type.Union([
    Type.Record(Type.String(), Type.Array(KagiSearchResultSchema)),
    Type.Null(),
  ]),
  errors: Type.Optional(
    Type.Array(
      Type.Object({
        code: Type.String(),
        message: Type.String(),
        url: Type.Optional(Type.String()),
      }),
    ),
  ),
});

/** Sections we know how to label, in the order we prefer to render them. */
const SECTION_ORDER = [
  'search',
  'video',
  'interesting_finds',
  'related_search',
];

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null;
}

/** Summarize (at most three) reasons why `raw` failed validation. */
function describeIssues(raw: unknown): string {
  return Errors(KagiResponseSchema, raw)
    .slice(0, 3)
    .map((e) => `${e.instancePath || '/'}: ${e.message}`)
    .join('; ');
}

/**
 * Errors the API reports about itself, read defensively because we may be
 * looking at a response that failed validation (or a non-2xx body).
 */
function apiErrors(raw: unknown): string[] {
  const errors = isRecord(raw) ? raw['errors'] : undefined;
  if (!Array.isArray(errors)) {
    return [];
  }
  return errors.map((error) => {
    if (!isRecord(error)) {
      return JSON.stringify(error);
    }
    const message = typeof error['message'] === 'string'
      ? error['message']
      : undefined;
    const code = typeof error['code'] === 'string' ? error['code'] : undefined;
    if (message && code) {
      return `${message} (${code})`;
    }
    return message ?? code ?? JSON.stringify(error);
  });
}

/**
 * Keep whatever individual results still validate when the response as a whole
 * does not: one unrecognized field shouldn't discard an entire (paid) query.
 */
function salvageSections(raw: unknown): KagiSections {
  const data = isRecord(raw) ? raw['data'] : undefined;
  if (!isRecord(data)) {
    return {};
  }
  const sections: KagiSections = {};
  for (const [name, items] of Object.entries(data)) {
    if (!Array.isArray(items)) {
      continue;
    }
    const valid = items.filter((item): item is KagiSearchResult =>
      Check(KagiSearchResultSchema, item)
    );
    if (valid.length) {
      sections[name] = valid;
    }
  }
  return sections;
}

/** `interesting_finds` -> `Interesting finds` */
function sectionLabel(name: string): string {
  const words = name.replace(/_/g, ' ');
  return words.charAt(0).toUpperCase() + words.slice(1);
}

function formatResult(item: KagiSearchResult): string {
  let entry = `## ${item.title ?? '(no title)'}`;
  if (item.url) {
    entry += `\n${item.url}`;
  }
  if (item.snippet) {
    entry += `\n${item.snippet}`;
  }
  if (item.time) {
    entry += `\nTime: ${item.time}`;
  }
  return entry;
}

function formatKagiResults(sections: KagiSections): string {
  const names = Object.keys(sections).sort((a, b) => {
    const ai = SECTION_ORDER.indexOf(a);
    const bi = SECTION_ORDER.indexOf(b);
    return (
      (ai === -1 ? SECTION_ORDER.length : ai) -
      (bi === -1 ? SECTION_ORDER.length : bi)
    );
  });

  const parts: string[] = [];
  for (const name of names) {
    const items = sections[name];
    if (!items?.length) {
      continue;
    }

    if (name === 'search') {
      // The primary results carry the section implicitly; no heading needed.
      for (const item of items) {
        if (item.url) {
          parts.push(formatResult(item));
        }
      }
      continue;
    }

    if (name === 'related_search') {
      // These URLs are relative to kagi.com and not useful to follow, so
      // surface the query text only.
      const queries = items
        .map((item) => item.title)
        .filter((title): title is string => Boolean(title));
      if (queries.length) {
        parts.push(`## Related searches\n${queries.join(', ')}`);
      }
      continue;
    }

    const lines = items
      .filter((item) => item.url || item.title)
      .map((item) => {
        const title = item.title ?? '(no title)';
        return item.url ? `- ${title}: ${item.url}` : `- ${title}`;
      });
    if (lines.length) {
      parts.push(`## ${sectionLabel(name)}\n${lines.join('\n')}`);
    }
  }
  return parts.join('\n\n');
}

async function searchKagi(
  query: string,
  token: string,
  context: ExtensionContext,
  signal?: AbortSignal,
) {
  const response = await fetch(KAGI_SEARCH_URL, {
    method: 'POST',
    headers: {
      'Authorization': `Bot ${token}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({query}),
    signal,
  });

  // v1 signals failure with an HTTP status as well as an `errors` array, so
  // prefer the structured message over the raw body when one is available.
  if (!response.ok) {
    const body = await response.text().catch(() => '');
    let parsed: unknown;
    try {
      parsed = JSON.parse(body);
    } catch {
      parsed = undefined;
    }
    const errors = apiErrors(parsed);
    throw new Error(
      `Kagi API error (${response.status}): ` +
        (errors.length ? errors.join('; ') : body || response.statusText),
    );
  }

  const raw: unknown = await response.json();

  const valid = Check(KagiResponseSchema, raw);
  const issues = valid ? undefined : describeIssues(raw);

  // Errors the API reports about itself are always fatal.
  const errors = apiErrors(raw);
  if (errors.length) {
    throw new Error(`Kagi API error: ${errors.join('; ')}`);
  }

  const sections = valid ? (raw.data ?? {}) : salvageSections(raw);

  // A bad shape alone is only a warning; give up only when nothing survived.
  const total = Object.values(sections).reduce(
    (sum, items) => sum + items.length,
    0,
  );
  if (issues !== undefined && total === 0) {
    throw new Error(
      `Kagi API returned an unexpected response shape: ${issues}`,
    );
  }

  const formatted = formatKagiResults(sections);
  const resultCount = sections['search']?.length ?? 0;

  if (context.hasUI) {
    if (valid) {
      // Show API request time as toast only (doesn't leak into session).
      context.ui.notify(`Kagi: ${raw.meta.ms} ms`, 'info');
    } else {
      context.ui.notify(
        `Kagi: unexpected response shape (${issues})`,
        'warning',
      );
    }
  }

  let text = formatted || 'No results found.';
  if (issues !== undefined) {
    text += `\n\n(Note: part of the Kagi response could not be parsed ` +
      `(${issues}); some results may be missing.)`;
  }

  return {
    content: [{type: 'text' as const, text}],
    details: {
      provider: 'kagi',
      query,
      resultCount,
      issues,
    },
  };
}

export default function webSearchExtension(pi: ExtensionAPI) {
  pi.registerTool({
    name: 'web_search',
    label: 'Web Search',
    description:
      'Search the web. Returns a list of results with titles, URLs, and snippets.',
    promptSnippet: 'Search the web for current information',
    promptGuidelines: [
      'Use web_search when the user asks for information that may require up-to-date web results.',
      'Prefer specific, targeted queries over broad ones.',
      'Summarize search results for the user rather than dumping raw output.',
    ],
    parameters: Type.Object({
      query: Type.String({description: 'Search query'}),
    }),

    async execute(_toolCallId, params, signal, _onUpdate, context) {
      const kagiToken = process.env.KAGI_API_TOKEN;
      const provider = process.env.PI_WEB_SEARCH_PROVIDER ??
        (kagiToken ? 'kagi' : 'parallel');
      if (provider === 'disabled') {
        throw new Error('web_search is disabled by PI_WEB_SEARCH_PROVIDER.');
      }
      if (provider === 'parallel') {
        return await searchParallel(params.query, context, signal);
      }
      if (provider !== 'kagi') {
        throw new Error(
          'PI_WEB_SEARCH_PROVIDER must be kagi, parallel, or disabled.',
        );
      }
      if (!kagiToken) {
        throw new Error(
          'web_search requires `KAGI_API_TOKEN` to be set in the environment.',
        );
      }

      return await searchKagi(
        params.query,
        kagiToken,
        context,
        signal,
      );
    },
  });
}
