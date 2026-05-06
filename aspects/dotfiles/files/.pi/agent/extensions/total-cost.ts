/**
 * Total Cost Extension
 *
 * Adds a `/total-cost` command that scans every saved pi session under
 * `$PI_CODING_AGENT_DIR/sessions` (default `~/.pi/agent/sessions`) and shows a
 * per-month breakdown of cumulative LLM cost, message count, and number of
 * distinct sessions that contributed.
 *
 * Costs come from the `usage.cost.total` field stored on each assistant
 * message. Months are bucketed by the entry-level ISO timestamp (UTC).
 */

import type {
  ExtensionAPI,
  ExtensionCommandContext,
} from '@mariozechner/pi-coding-agent';
import {DynamicBorder} from '@mariozechner/pi-coding-agent';
import {Container, Text, matchesKey} from '@mariozechner/pi-tui';
import {readFile, readdir, stat} from 'node:fs/promises';
import {homedir} from 'node:os';
import {join} from 'node:path';

interface MonthBucket {
  month: string; // YYYY-MM
  cost: number;
  messages: number;
  sessions: Set<string>;
}

interface Totals {
  cost: number;
  messages: number;
  sessions: number;
  files: number;
  skippedFiles: number;
  byMonth: MonthBucket[];
}

function getSessionsDir(): string {
  const base = process.env.PI_CODING_AGENT_DIR?.trim() ||
    join(homedir(), '.pi', 'agent');
  return join(base, 'sessions');
}

async function listSessionFiles(dir: string): Promise<string[]> {
  const result: string[] = [];
  let projectDirs: string[];
  try {
    projectDirs = await readdir(dir);
  } catch {
    return result;
  }

  for (const project of projectDirs) {
    const projectPath = join(dir, project);
    let files: string[];
    try {
      const st = await stat(projectPath);
      if (!st.isDirectory()) { continue; }
      files = await readdir(projectPath);
    } catch {
      continue;
    }
    for (const file of files) {
      if (file.endsWith('.jsonl')) {
        result.push(join(projectPath, file));
      }
    }
  }
  return result;
}

function bucketKey(timestamp: string | number | undefined): string | null {
  if (timestamp === undefined || timestamp === null) { return null; }
  const d = typeof timestamp === 'number'
    ? new Date(timestamp)
    : new Date(timestamp);
  if (Number.isNaN(d.getTime())) { return null; }
  const year = d.getUTCFullYear();
  const month = String(d.getUTCMonth() + 1).padStart(2, '0');
  return `${year}-${month}`;
}

async function computeTotals(): Promise<Totals> {
  const sessionsDir = getSessionsDir();
  const files = await listSessionFiles(sessionsDir);

  const buckets = new Map<string, MonthBucket>();
  let totalCost = 0;
  let totalMessages = 0;
  const allSessions = new Set<string>();
  let skippedFiles = 0;

  for (const file of files) {
    let raw: string;
    try {
      raw = await readFile(file, 'utf8');
    } catch {
      skippedFiles++;
      continue;
    }

    const lines = raw.split('\n');
    for (const line of lines) {
      if (!line) { continue; }
      let entry: any;
      try {
        entry = JSON.parse(line);
      } catch {
        continue; // tolerate corrupt/partial trailing lines
      }

      if (entry?.type !== 'message') { continue; }
      const message = entry.message;
      if (!message || message.role !== 'assistant') { continue; }

      const cost = message.usage?.cost?.total;
      if (
        typeof cost !== 'number' || !Number.isFinite(cost) || cost <= 0
      ) { continue; }

      // Prefer entry-level ISO timestamp; fall back to message timestamp (unix ms).
      const month = bucketKey(entry.timestamp) ?? bucketKey(message.timestamp);
      if (!month) { continue; }

      let bucket = buckets.get(month);
      if (!bucket) {
        bucket = {month, cost: 0, messages: 0, sessions: new Set()};
        buckets.set(month, bucket);
      }
      bucket.cost += cost;
      bucket.messages += 1;
      bucket.sessions.add(file);

      totalCost += cost;
      totalMessages += 1;
      allSessions.add(file);
    }
  }

  const byMonth = [...buckets.values()].sort((
    a,
    b,
  ) => (a.month < b.month ? 1 : -1));

  return {
    cost: totalCost,
    messages: totalMessages,
    sessions: allSessions.size,
    files: files.length,
    skippedFiles,
    byMonth,
  };
}

function fmtMoney(n: number): string {
  return `$${n.toFixed(2)}`;
}

function fmtInt(n: number): string {
  return n.toLocaleString('en-US');
}

function buildLines(totals: Totals, theme: any): string[] {
  const lines: string[] = [];

  if (totals.byMonth.length === 0) {
    lines.push(theme.fg('muted', 'No sessions with cost data found.'));
    lines.push(
      theme.fg(
        'dim',
        `Scanned ${
          fmtInt(totals.files)
        } session file(s) in ${getSessionsDir()}`,
      ),
    );
    return lines;
  }

  // Column widths
  const monthW = 7; // YYYY-MM
  const costW = Math.max(
    8,
    ...totals.byMonth.map((b) => fmtMoney(b.cost).length),
    fmtMoney(totals.cost).length,
  );
  const msgW = Math.max(
    8,
    ...totals.byMonth.map((b) => fmtInt(b.messages).length),
  );
  const sessW = Math.max(
    8,
    ...totals.byMonth.map((b) => fmtInt(b.sessions.size).length),
  );

  const padL = (s: string, w: number) =>
    s + ' '.repeat(Math.max(0, w - s.length));
  const padR = (s: string, w: number) =>
    ' '.repeat(Math.max(0, w - s.length)) + s;

  const header = theme.fg('muted', padL('Month', monthW)) +
    '  ' +
    theme.fg('muted', padR('Cost', costW)) +
    '  ' +
    theme.fg('muted', padR('Messages', msgW)) +
    '  ' +
    theme.fg('muted', padR('Sessions', sessW));
  lines.push(header);
  lines.push(
    theme.fg('dim', '─'.repeat(monthW + 2 + costW + 2 + msgW + 2 + sessW)),
  );

  for (const b of totals.byMonth) {
    lines.push(
      theme.fg('accent', padL(b.month, monthW)) +
        '  ' +
        theme.fg('warning', padR(fmtMoney(b.cost), costW)) +
        '  ' +
        theme.fg('dim', padR(fmtInt(b.messages), msgW)) +
        '  ' +
        theme.fg('dim', padR(fmtInt(b.sessions.size), sessW)),
    );
  }

  lines.push(
    theme.fg('dim', '─'.repeat(monthW + 2 + costW + 2 + msgW + 2 + sessW)),
  );
  lines.push(
    theme.bold(theme.fg('accent', padL('Total', monthW))) +
      '  ' +
      theme.bold(theme.fg('warning', padR(fmtMoney(totals.cost), costW))) +
      '  ' +
      theme.bold(theme.fg('muted', padR(fmtInt(totals.messages), msgW))) +
      '  ' +
      theme.bold(theme.fg('muted', padR(fmtInt(totals.sessions), sessW))),
  );
  lines.push('');
  lines.push(
    theme.fg(
      'dim',
      `Scanned ${fmtInt(totals.files)} session file(s) in ${getSessionsDir()}`,
    ) +
      (totals.skippedFiles > 0
        ? theme.fg('warning', `, skipped ${totals.skippedFiles}`)
        : ''),
  );

  return lines;
}

async function showTotals(
  totals: Totals,
  ctx: ExtensionCommandContext,
): Promise<void> {
  if (!ctx.hasUI) {
    // Fallback for non-interactive modes: print plain text.
    const plain: string[] = [];
    plain.push('Total Cost by Month');
    plain.push('===================');
    for (const b of totals.byMonth) {
      plain.push(
        `${b.month}  ${fmtMoney(b.cost).padStart(10)}  ${
          fmtInt(b.messages).padStart(8)
        } msgs  ${fmtInt(b.sessions.size).padStart(4)} sessions`,
      );
    }
    plain.push('-------------------');
    plain.push(
      `Total     ${fmtMoney(totals.cost).padStart(10)}  ${
        fmtInt(totals.messages).padStart(8)
      } msgs  ${fmtInt(totals.sessions).padStart(4)} sessions`,
    );
    console.log(plain.join('\n'));
    return;
  }

  await ctx.ui.custom((_tui, theme, _kb, done) => {
    const container = new Container();
    const border = new DynamicBorder((s: string) => theme.fg('accent', s));
    container.addChild(border);
    container.addChild(
      new Text(theme.fg('accent', theme.bold('Total Cost by Month')), 1, 1),
    );
    for (const line of buildLines(totals, theme)) {
      container.addChild(new Text(line, 1, 0));
    }
    container.addChild(
      new Text(theme.fg('dim', 'Press Enter or Esc to close'), 1, 1),
    );
    container.addChild(border);

    return {
      render: (width: number) => container.render(width),
      invalidate: () => container.invalidate(),
      handleInput: (data: string) => {
        if (matchesKey(data, 'enter') || matchesKey(data, 'escape')) {
          done(undefined);
        }
      },
    };
  });
}

export default function (pi: ExtensionAPI) {
  pi.registerCommand('total-cost', {
    description:
      'Show total LLM cost across all sessions, broken down by month',
    handler: async (_args, ctx) => {
      if (ctx.hasUI) {
        ctx.ui.notify('Computing total cost across sessions…', 'info');
      }
      let totals: Totals;
      try {
        totals = await computeTotals();
      } catch (err) {
        const msg = err instanceof Error ? err.message : String(err);
        if (ctx.hasUI) {
          ctx.ui.notify(`Failed to compute totals: ${msg}`, 'error');
        } else { console.error(`Failed to compute totals: ${msg}`); }
        return;
      }
      await showTotals(totals, ctx);
    },
  });
}
