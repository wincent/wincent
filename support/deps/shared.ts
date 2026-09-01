import {selectByPatterns} from '../dependencies.ts';

/**
 * Blurb appended to the `--help` output of every subcommand that accepts
 * pattern arguments.
 */
export const PATTERN_HELP: string = `
With no patterns, every dependency is included. Otherwise, only
dependencies matching at least one pattern are. Matching is
case-insensitive substring matching against both the dependency id
(eg. "github/wincent/command-t") and its installed path (eg.
"aspects/nvim/files/.config/nvim/pack/bundle/opt/command-t").
`.trim();

export function bail(err: unknown): never {
  console.error(err instanceof Error ? `error: ${err.message}` : err);
  console.log("For more information, try '--help'");
  process.exit(1);
}

/**
 * Applies pattern filtering, exiting cleanly if patterns were supplied but
 * matched nothing (there is no work to do, but it is not an error).
 */
export function select<T>(
  items: Array<T>,
  patterns: Array<string>,
  getKey: (item: T) => {id: string; prefix: string},
  verb: string,
): Array<T> {
  const selected = selectByPatterns(items, patterns, getKey, verb);

  if (patterns.length > 0 && selected.length === 0) {
    console.log('No dependencies matched the given pattern(s); nothing to do.');
    process.exit(0);
  }

  return selected;
}

/**
 * Runs `task` over `items` with bounded concurrency, preserving input order in
 * the returned results.
 */
export async function batch<T, U>(
  items: Array<T>,
  size: number,
  task: (item: T) => Promise<U>,
): Promise<Array<U>> {
  const results: Array<U> = [];

  for (let i = 0; i < items.length; i += size) {
    results.push(...await Promise.all(items.slice(i, i + size).map(task)));
  }

  return results;
}

export type Issue = {
  level: 'error' | 'warning';
  prefix: string;
  message: string;
};

/**
 * Collects problems so that they can be re-printed in a summary at the end,
 * where they will not be lost in the output of a 70-dependency run.
 */
export class Issues {
  _issues: Array<Issue> = [];

  get length(): number {
    return this._issues.length;
  }

  warn(prefix: string, message: string): void {
    console.warn(`warning: [${prefix}] ${message}`);
    this._issues.push({level: 'warning', prefix, message});
  }

  fail(prefix: string, message: string): void {
    console.error(`error: [${prefix}] ${message}`);
    this._issues.push({level: 'error', prefix, message});
  }

  /**
   * Prints a summary and exits non-zero if anything was collected, so that
   * incomplete runs cannot pass unnoticed.
   */
  report(title: string, epilogue: string): void {
    if (this._issues.length === 0) {
      return;
    }

    const errors = this._issues.filter(({level}) => level === 'error');
    const warnings = this._issues.filter(({level}) => level === 'warning');

    console.error('\n' + '='.repeat(80));
    console.error(title);
    console.error('='.repeat(80) + '\n');

    for (const {level, prefix, message} of [...errors, ...warnings]) {
      console.error(
        `* ${level.toUpperCase().padEnd(7)} [${prefix}] ${message}`,
      );
    }

    const parts: Array<string> = [];
    if (errors.length > 0) {
      parts.push(
        `${errors.length} ${errors.length === 1 ? 'error' : 'errors'}`,
      );
    }
    if (warnings.length > 0) {
      parts.push(
        `${warnings.length} ${warnings.length === 1 ? 'warning' : 'warnings'}`,
      );
    }

    console.error('\n' + '='.repeat(80));
    console.error(`${parts.join(', ')} (${epilogue})`);
    console.error('='.repeat(80));

    process.exit(1);
  }
}

/**
 * Renders a left-aligned table, sizing each column to its widest cell.
 */
export function table(
  headings: Array<string>,
  rows: Array<Array<string>>,
): string {
  const widths = headings.map((heading, i) =>
    Math.max(heading.length, ...rows.map((row) => (row[i] ?? '').length))
  );

  const format = (cells: Array<string>) =>
    cells
      .map((
        cell,
        i,
      ) => (i === cells.length - 1 ? cell : cell.padEnd(widths[i]!)))
      .join('  ')
      .trimEnd();

  const total = widths.reduce((sum, width) => sum + width + 2, -2);

  return [format(headings), '-'.repeat(total), ...rows.map(format)].join('\n');
}
