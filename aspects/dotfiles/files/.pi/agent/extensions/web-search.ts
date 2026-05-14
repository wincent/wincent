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

const KagiSearchResultSchema = Type.Object({
  t: Type.Number(),
  url: Type.Optional(Type.String()),
  title: Type.Optional(Type.String()),
  snippet: Type.Optional(Type.String()),
  published: Type.Optional(Type.String()),
  list: Type.Optional(Type.Array(Type.String())),
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

  if (!Check(KagiResponseSchema, raw)) {
    const issues = Errors(KagiResponseSchema, raw)
      .slice(0, 3)
      .map((e) => `${e.instancePath || '/'}: ${e.message}`)
      .join('; ');
    throw new Error(
      `Kagi API returned an unexpected response shape: ${issues}`,
    );
  }
  const json = raw;

  if (json.error?.length) {
    throw new Error(
      `Kagi API error: ${json.error.map((e) => e.msg).join('; ')}`,
    );
  }

  const formatted = formatKagiResults(json.data);
  const resultCount = json.data.filter((d) => d.t === 0).length;

  if (context.hasUI) {
    // Show API request time and remaining balance as toast only
    // (doesn't leak into session).
    const parts = [`${json.meta.ms} ms`];
    if (typeof json.meta.api_balance === 'number') {
      parts.push(`balance $${json.meta.api_balance.toFixed(2)}`);
    }
    context.ui.notify(`Kagi: ${parts.join(', ')}`, 'info');
  }

  return {
    content: [{type: 'text' as const, text: formatted || 'No results found.'}],
    details: {
      provider: 'kagi',
      query,
      resultCount,
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
