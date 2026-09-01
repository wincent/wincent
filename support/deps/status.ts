import {basename} from 'node:path';
import {parseArgs} from 'node:util';

import type {Status} from '../dependencies.ts';
import {
  classify,
  formatAge,
  hasLocalDrift,
  load,
  shortHash,
} from '../dependencies.ts';
import {PATTERN_HELP, bail, batch, select, table} from './shared.ts';

const HELP = `
Usage: bin/deps status [options] [pattern...]

Report how the four tiers of dependency state relate to each other:

  1. the remote, ie. origin/<branch> as of the last fetch
  2. the lockfile, ie. the commit pinned in dependencies.json
  3. the cache, ie. the checkout under .cache/repos
  4. the worktree, ie. the copy committed to this repo

This command is entirely offline and read-only: it never fetches and
never writes. That means the "Remote" column is only as fresh as the
last \`bin/deps fetch\`, which is why the "Fetched" column exists.

  bin/deps status                    # previews what \`sync\` would do
  bin/deps fetch && bin/deps status  # previews what \`update\` would do

Options:
  -a, --all       List every dependency, not just the interesting ones
      --no-worktree
                  Skip the worktree comparison, which needs one rsync
                  dry run per dependency (faster, but the "Worktree"
                  column reads "skipped")

The "Worktree" column counts files a sync would update (~) or delete
(-). Files that git ignores are counted separately, because a sync
churns them but nothing version-controlled changes; they never count
as drift.
      --exit-zero Always exit 0, even when there is local drift

Exits non-zero when the lockfile, cache and worktree disagree, ie.
when something needs your attention. Upstream having moved on is
reported but never affects the exit status.

${PATTERN_HELP}

Examples:
  bin/deps status command-t     # just command-t
  bin/deps status nvim          # every nvim plugin
  bin/deps status --all --no-worktree
`.trim();

const CACHE_LABELS: { [key in Status['cache']]: string } = {
  absent: 'absent',
  ahead: 'ahead',
  behind: 'behind',
  clean: 'clean',
  diverged: 'diverged',
  missing: 'not cloned',
  unknown: 'unknown',
};

const EXPLANATIONS: {[key: string]: string} = {
  absent: 'pinned commit is missing from the cache; run `bin/deps fetch`',
  ahead: 'cache has commits the lockfile does not; run `bin/deps update`',
  behind: 'cache is behind the lockfile; run `bin/deps sync --with-lockfile`',
  dirty: 'cache has uncommitted changes',
  diverged: 'cache has diverged from the lockfile',
  churn: 'worktree differs only in files git ignores; harmless',
  drift: 'worktree differs from the cache; run `bin/deps sync`',
  missing: 'not cloned yet; run `bin/deps seed`',
  rewound: 'remote no longer contains the pinned commit (force push?)',
  unknown: 'could not resolve HEAD in the cache',
  worktreeMissing: 'not present in the worktree; run `bin/deps sync`',
};

function describeCache(status: Status): string {
  const label = CACHE_LABELS[status.cache];

  if (status.cache === 'missing') {
    return label;
  }

  return `${label}${status.dirty ? ' +dirty' : ''}`;
}

function describeWorktree(status: Status, checked: boolean): string {
  if (!checked) {
    return status.worktree === 'missing' ? 'not present' : 'skipped';
  }

  const {deleted, ignored, updated} = status.diff;

  switch (status.worktree) {
    case 'clean':
      return 'clean';
    case 'missing':
      return 'not present';
    case 'churn':
      return `${ignored} ignored`;
    case 'drift': {
      const parts: Array<string> = [];
      if (updated > 0) {
        parts.push(`~${updated}`);
      }
      if (deleted > 0) {
        parts.push(`-${deleted}`);
      }
      if (ignored > 0) {
        parts.push(`(${ignored} ignored)`);
      }
      return parts.join(' ');
    }
  }
}

function describeRemote(status: Status): string {
  switch (status.remote) {
    case 'available':
      return `+${status.pending}`;
    case 'current':
      return 'up to date';
    case 'rewound':
      return 'rewound';
    case 'unfetched':
      return 'unfetched';
  }
}

/**
 * Reasons this dependency is worth showing when not in `--all` mode.
 */
function reasons(status: Status): Array<string> {
  const found: Array<string> = [];

  if (status.cache !== 'clean') {
    found.push(status.cache);
  }
  if (status.dirty) {
    found.push('dirty');
  }
  if (status.worktree === 'drift') {
    found.push('drift');
  } else if (status.worktree === 'missing') {
    found.push('worktreeMissing');
  }
  // Note: 'churn' is deliberately absent, so that dependencies differing only
  // in ignored artifacts stay out of the default listing.
  if (status.remote === 'available') {
    found.push('available');
  } else if (status.remote === 'rewound') {
    found.push('rewound');
  }

  return found;
}

/**
 * Prefer the last path segment as a display name, but fall back to the full id
 * for any name claimed by more than one dependency.
 */
function displayNames(statuses: Array<Status>): Map<string, string> {
  const counts = new Map<string, number>();

  for (const {prefix} of statuses) {
    const name = basename(prefix);
    counts.set(name, (counts.get(name) ?? 0) + 1);
  }

  return new Map(
    statuses.map(({id, prefix}) => {
      const name = basename(prefix);
      return [id, counts.get(name) === 1 ? name : id];
    }),
  );
}

export async function run(args: Array<string>): Promise<void> {
  const {
    values: {all, ['exit-zero']: exitZero, help, ['no-worktree']: noWorktree},
    positionals: patterns,
  } = (() => {
    try {
      return parseArgs({
        args,
        options: {
          all: {type: 'boolean', short: 'a'},
          ['exit-zero']: {type: 'boolean'},
          help: {type: 'boolean', short: 'h'},
          ['no-worktree']: {type: 'boolean'},
        },
        allowPositionals: true,
      });
    } catch (err) {
      return bail(err);
    }
  })();

  const worktree = !noWorktree;

  if (help) {
    console.log(HELP);
    return;
  }

  const entries = select(
    Object.entries(load()),
    patterns,
    ([id, entry]) => ({id, prefix: entry.prefix}),
    'Inspecting',
  );

  const statuses = await batch(
    entries,
    8,
    async ([id, entry]) => classify(id, entry, {worktree}),
  );

  const names = displayNames(statuses);
  const interesting = statuses.filter((status) => reasons(status).length > 0);
  const shown = all ? statuses : interesting;

  if (shown.length > 0) {
    const rows = shown.map((
      status,
    ) => [
      names.get(status.id)!,
      shortHash(status.pinned),
      describeCache(status),
      describeWorktree(status, worktree),
      describeRemote(status),
      formatAge(status.fetchedAt),
    ]);

    console.log(
      table(
        ['Dependency', 'Pinned', 'Cache', 'Worktree', 'Remote', 'Fetched'],
        rows,
      ),
    );
  }

  // Explain each distinct condition once, rather than per dependency.
  const seen = new Set(shown.flatMap(reasons));
  const notes = [...seen]
    .filter((reason) => reason in EXPLANATIONS)
    .sort()
    .map((reason) => `  ${reason}: ${EXPLANATIONS[reason]}`);

  if (notes.length > 0) {
    console.log('\nNotes:');
    console.log(notes.join('\n'));
  }

  const drifted = statuses.filter(hasLocalDrift);
  const available = statuses.filter(({remote}) => remote === 'available');
  const unfetched = statuses.filter(({remote}) => remote === 'unfetched');

  console.log();

  if (drifted.length === 0) {
    console.log(
      `${statuses.length} ${
        statuses.length === 1 ? 'dependency' : 'dependencies'
      }: lockfile, cache and worktree agree.`,
    );
  } else {
    console.log(
      `${drifted.length} of ${statuses.length} ${
        statuses.length === 1 ? 'dependency' : 'dependencies'
      } ${drifted.length === 1 ? 'has' : 'have'} local drift.`,
    );
  }

  if (available.length > 0) {
    const commits = available.reduce((sum, {pending}) => sum + pending, 0);
    console.log(
      `${available.length} ${
        available.length === 1 ? 'dependency has' : 'dependencies have'
      } ${commits} ${
        commits === 1 ? 'commit' : 'commits'
      } available upstream; run \`bin/deps update\`.`,
    );
  }

  // A stale or absent fetch makes the "Remote" column quietly misleading, so
  // say so rather than letting it look authoritative.
  const oldest = statuses
    .map(({fetchedAt}) => fetchedAt)
    .reduce<Date | null>(
      (
        min,
        date,
      ) => (date == null || (min != null && min <= date) ? min : date),
      statuses.length > 0 ? statuses[0]!.fetchedAt : null,
    );

  if (unfetched.length === statuses.length && statuses.length > 0) {
    console.log('Remote state is unknown; run `bin/deps fetch`.');
  } else if (oldest != null) {
    const age = Date.now() - oldest.getTime();
    const stale = age > 1000 * 60 * 60 * 24;
    console.log(
      `Remote state is as of ${formatAge(oldest)} (oldest fetch)${
        stale ? '; run `bin/deps fetch` to refresh' : ''
      }.`,
    );
  }

  if (drifted.length > 0 && !exitZero) {
    process.exit(1);
  }
}
