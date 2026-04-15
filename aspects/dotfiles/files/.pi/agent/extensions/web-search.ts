/**
 * Web Search Extension
 *
 * Registers a `web_search` tool with two backends:
 *
 * 1. **Kagi Search API** (preferred) — requires `KAGI_API_TOKEN` env var.
 *    High-quality results at 2.5¢/query.
 *
 * 2. **Exa MCP free tier** (fallback) — no API key needed.
 *    Calls https://mcp.exa.ai/mcp with no auth. Free but no SLA.
 *
 * The tool is always active. When a Kagi token is available it is used;
 * otherwise queries fall through to Exa automatically.
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { Type } from "@sinclair/typebox";

// ---------------------------------------------------------------------------
// Kagi
// ---------------------------------------------------------------------------

const KAGI_SEARCH_URL = "https://kagi.com/api/v0/search";

interface KagiSearchResult {
	t: number;
	url?: string;
	title?: string;
	snippet?: string;
	published?: string;
	list?: string[];
}

interface KagiResponse {
	meta: { id: string; node: string; ms: number; api_balance?: number };
	data: KagiSearchResult[];
	error?: Array<{ code: number; msg: string }>;
}

function formatKagiResults(data: KagiSearchResult[]): string {
	const parts: string[] = [];
	for (const item of data) {
		if (item.t === 0 && item.url) {
			let entry = `## ${item.title ?? "(no title)"}\n${item.url}`;
			if (item.snippet) entry += `\n${item.snippet}`;
			if (item.published) entry += `\nPublished: ${item.published}`;
			parts.push(entry);
		} else if (item.t === 1 && item.list) {
			parts.push(`## Related searches\n${item.list.join(", ")}`);
		}
	}
	return parts.join("\n\n");
}

async function searchKagi(
	query: string,
	limit: number | undefined,
	token: string,
	signal?: AbortSignal,
) {
	const url = new URL(KAGI_SEARCH_URL);
	url.searchParams.set("q", query);
	if (limit) url.searchParams.set("limit", String(limit));

	const response = await fetch(url.toString(), {
		headers: { Authorization: `Bot ${token}` },
		signal,
	});

	if (!response.ok) {
		const body = await response.text().catch(() => "");
		throw new Error(`Kagi API error (${response.status}): ${body || response.statusText}`);
	}

	const json = (await response.json()) as KagiResponse;

	if (json.error?.length) {
		throw new Error(`Kagi API error: ${json.error.map((e) => e.msg).join("; ")}`);
	}

	const formatted = formatKagiResults(json.data);
	const resultCount = json.data.filter((d) => d.t === 0).length;

	return {
		content: [{ type: "text" as const, text: formatted || "No results found." }],
		details: {
			provider: "kagi",
			query,
			resultCount,
			apiTimeMs: json.meta.ms,
			apiBalance: json.meta.api_balance,
		},
	};
}

// ---------------------------------------------------------------------------
// Exa MCP (free tier fallback)
// ---------------------------------------------------------------------------

const EXA_MCP_URL = "https://mcp.exa.ai/mcp";

interface ExaMcpRpcResponse {
	result?: {
		content?: Array<{ type?: string; text?: string }>;
		isError?: boolean;
	};
	error?: { code?: number; message?: string };
}

interface ExaParsedResult {
	title: string;
	url: string;
	content: string;
}

/** Send a JSON-RPC tool call to the Exa MCP endpoint. */
async function callExaMcp(
	query: string,
	numResults: number,
	signal?: AbortSignal,
): Promise<string> {
	const response = await fetch(EXA_MCP_URL, {
		method: "POST",
		headers: {
			"Content-Type": "application/json",
			Accept: "application/json, text/event-stream",
		},
		body: JSON.stringify({
			jsonrpc: "2.0",
			id: 1,
			method: "tools/call",
			params: {
				name: "web_search_exa",
				arguments: {
					query,
					numResults,
					livecrawl: "fallback",
					type: "auto",
					contextMaxCharacters: 3000,
				},
			},
		}),
		signal,
	});

	if (!response.ok) {
		const text = await response.text().catch(() => "");
		throw new Error(`Exa MCP error (${response.status}): ${text.slice(0, 300)}`);
	}

	const body = await response.text();

	// Response may be SSE (data: lines) or plain JSON.
	let parsed: ExaMcpRpcResponse | null = null;

	const dataLines = body.split("\n").filter((l) => l.startsWith("data:"));
	for (const line of dataLines) {
		const payload = line.slice(5).trim();
		if (!payload) continue;
		try {
			const candidate = JSON.parse(payload) as ExaMcpRpcResponse;
			if (candidate?.result || candidate?.error) {
				parsed = candidate;
				break;
			}
		} catch {}
	}

	if (!parsed) {
		try {
			const candidate = JSON.parse(body) as ExaMcpRpcResponse;
			if (candidate?.result || candidate?.error) parsed = candidate;
		} catch {}
	}

	if (!parsed) throw new Error("Exa MCP returned an empty response");

	if (parsed.error) {
		const code = typeof parsed.error.code === "number" ? ` ${parsed.error.code}` : "";
		throw new Error(`Exa MCP error${code}: ${parsed.error.message || "Unknown error"}`);
	}

	if (parsed.result?.isError) {
		const msg = parsed.result.content?.find(
			(c) => c.type === "text" && c.text?.trim(),
		)?.text?.trim();
		throw new Error(msg || "Exa MCP returned an error");
	}

	const text = parsed.result?.content?.find(
		(c) => c.type === "text" && typeof c.text === "string" && c.text.trim().length > 0,
	)?.text;

	if (!text) throw new Error("Exa MCP returned empty content");

	return text;
}

/** Parse the MCP text blob into structured results. */
function parseExaResults(text: string): ExaParsedResult[] {
	const blocks = text.split(/(?=^Title: )/m).filter((b) => b.trim().length > 0);
	return blocks
		.map((block) => {
			const title = block.match(/^Title: (.+)/m)?.[1]?.trim() ?? "";
			const url = block.match(/^URL: (.+)/m)?.[1]?.trim() ?? "";
			let content = "";
			const textStart = block.indexOf("\nText: ");
			if (textStart >= 0) {
				content = block.slice(textStart + 7).trim();
			} else {
				const hlMatch = block.match(/\nHighlights:\s*\n/);
				if (hlMatch?.index != null) {
					content = block.slice(hlMatch.index + hlMatch[0].length).trim();
				}
			}
			content = content.replace(/\n---\s*$/, "").trim();
			return { title, url, content };
		})
		.filter((r) => r.url.length > 0);
}

function formatExaResults(results: ExaParsedResult[]): string {
	return results
		.map((r) => {
			let entry = `## ${r.title || "(no title)"}\n${r.url}`;
			if (r.content) entry += `\n${r.content}`;
			return entry;
		})
		.join("\n\n");
}

async function searchExa(
	query: string,
	limit: number | undefined,
	signal?: AbortSignal,
) {
	const text = await callExaMcp(query, limit ?? 5, signal);
	const results = parseExaResults(text);

	return {
		content: [
			{
				type: "text" as const,
				text: results.length > 0 ? formatExaResults(results) : "No results found.",
			},
		],
		details: {
			provider: "exa-mcp",
			query,
			resultCount: results.length,
		},
	};
}

// ---------------------------------------------------------------------------
// Extension
// ---------------------------------------------------------------------------

export default function webSearchExtension(pi: ExtensionAPI) {
	pi.registerTool({
		name: "web_search",
		label: "Web Search",
		description:
			"Search the web. Returns a list of results with titles, URLs, and snippets. " +
			"Uses Kagi when KAGI_API_TOKEN is set, otherwise falls back to Exa free tier.",
		promptSnippet: "Search the web for current information",
		promptGuidelines: [
			"Use web_search when the user asks for information that may require up-to-date web results.",
			"Prefer specific, targeted queries over broad ones.",
			"Summarize search results for the user rather than dumping raw output.",
		],
		parameters: Type.Object({
			query: Type.String({ description: "Search query" }),
			limit: Type.Optional(
				Type.Number({ description: "Max number of results (default: 5 for Exa, 10 for Kagi)" }),
			),
		}),

		async execute(_toolCallId, params, signal) {
			const kagiToken = process.env.KAGI_API_TOKEN;

			// Try Kagi first if a token is available.
			if (kagiToken) {
				try {
					return await searchKagi(params.query, params.limit, kagiToken, signal);
				} catch (err) {
					// If Kagi fails, fall through to Exa rather than erroring out.
					const msg = err instanceof Error ? err.message : String(err);
					if (signal?.aborted) {
						return {
							content: [{ type: "text", text: "Search cancelled." }],
							isError: true,
						};
					}
					// Fall through with a note about the Kagi failure.
					try {
						const exaResult = await searchExa(params.query, params.limit, signal);
						exaResult.content[0].text =
							`(Kagi failed: ${msg} — fell back to Exa)\n\n` + exaResult.content[0].text;
						return exaResult;
					} catch (exaErr) {
						const exaMsg = exaErr instanceof Error ? exaErr.message : String(exaErr);
						return {
							content: [
								{
									type: "text",
									text: `Both search backends failed.\nKagi: ${msg}\nExa: ${exaMsg}`,
								},
							],
							isError: true,
						};
					}
				}
			}

			// No Kagi token — use Exa directly.
			try {
				return await searchExa(params.query, params.limit, signal);
			} catch (err) {
				if (signal?.aborted) {
					return {
						content: [{ type: "text", text: "Search cancelled." }],
						isError: true,
					};
				}
				const msg = err instanceof Error ? err.message : String(err);
				return {
					content: [{ type: "text", text: `Exa search failed: ${msg}` }],
					isError: true,
				};
			}
		},
	});
}
