/**
 * Web Search Extension
 *
 * Registers a `web_search` tool that uses the Kagi Search API
 * (https://help.kagi.com/kagi/api/search.html) at a cost of $25 per 1,000
 * queries (ie. 2.5 cents per query).
 *
 * Requires `KAGI_API_TOKEN` in the environment.
 */

import type {
  ExtensionAPI,
  ExtensionContext,
} from '@earendil-works/pi-coding-agent';
import {type Static, Type} from 'typebox';
import {Check, Errors} from 'typebox/value';

const KAGI_SEARCH_URL = 'https://kagi.com/api/v0/search';

/**
 * Kagi sends an explicit `null` (rather than omitting the key) for fields it
 * has no value for. Most commonly `snippet`, on results whose page has no
 * usable description.
 */
const NullableString = Type.Union([Type.String(), Type.Null()]);

const KagiSearchResultSchema = Type.Object({
  t: Type.Number(),
  url: Type.Optional(NullableString),
  title: Type.Optional(NullableString),
  snippet: Type.Optional(NullableString),
  published: Type.Optional(NullableString),
  list: Type.Optional(Type.Union([Type.Array(Type.String()), Type.Null()])),
});
type KagiSearchResult = Static<typeof KagiSearchResultSchema>;

const KagiResponseSchema = Type.Object({
  meta: Type.Object({
    id: Type.String(),
    node: Type.String(),
    ms: Type.Number(),
    api_balance: Type.Optional(Type.Number()),
  }),
  data: Type.Array(KagiSearchResultSchema),
  error: Type.Optional(
    Type.Array(
      Type.Object({
        code: Type.Number(),
        msg: Type.String(),
      }),
    ),
  ),
});

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
 * looking at a response that failed validation.
 */
function apiErrors(raw: unknown): string[] {
  const errors = isRecord(raw) ? raw['error'] : undefined;
  if (!Array.isArray(errors)) {
    return [];
  }
  return errors.map((error) =>
    isRecord(error) && typeof error['msg'] === 'string'
      ? error['msg']
      : JSON.stringify(error),
  );
}

/**
 * Keep whatever individual results still validate when the response as a whole
 * does not: one unrecognized field shouldn't discard an entire (paid) query.
 */
function salvageResults(raw: unknown): KagiSearchResult[] {
  const data = isRecord(raw) ? raw['data'] : undefined;
  if (!Array.isArray(data)) {
    return [];
  }
  return data.filter((item): item is KagiSearchResult =>
    Check(KagiSearchResultSchema, item),
  );
}

function formatKagiResults(data: KagiSearchResult[]): string {
  const parts: string[] = [];
  for (const item of data) {
    if (item.t === 0 && item.url) {
      let entry = `## ${item.title ?? '(no title)'}\n${item.url}`;
      if (item.snippet) {
        entry += `\n${item.snippet}`;
      }
      if (item.published) {
        entry += `\nPublished: ${item.published}`;
      }
      parts.push(entry);
    } else if (item.t === 1 && item.list) {
      parts.push(`## Related searches\n${item.list.join(', ')}`);
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
  const url = new URL(KAGI_SEARCH_URL);
  url.searchParams.set('q', query);

  const response = await fetch(url.toString(), {
    headers: {Authorization: `Bot ${token}`},
    signal,
  });

  if (!response.ok) {
    const body = await response.text().catch(() => '');
    throw new Error(
      `Kagi API error (${response.status}): ${body || response.statusText}`,
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

  const data = valid ? raw.data : salvageResults(raw);

  // A bad shape alone is only a warning; give up only when nothing survived.
  if (issues !== undefined && data.length === 0) {
    throw new Error(
      `Kagi API returned an unexpected response shape: ${issues}`,
    );
  }

  const formatted = formatKagiResults(data);
  const resultCount = data.filter((d) => d.t === 0).length;

  if (context.hasUI) {
    if (valid) {
      // Show API request time and remaining balance as toast only
      // (doesn't leak into session).
      const parts = [`${raw.meta.ms} ms`];
      if (typeof raw.meta.api_balance === 'number') {
        parts.push(`balance $${raw.meta.api_balance.toFixed(2)}`);
      }
      context.ui.notify(`Kagi: ${parts.join(', ')}`, 'info');
    } else {
      context.ui.notify(
        `Kagi: unexpected response shape (${issues})`,
        'warning',
      );
    }
  }

  let text = formatted || 'No results found.';
  if (issues !== undefined) {
    text +=
      `\n\n(Note: part of the Kagi response could not be parsed ` +
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
