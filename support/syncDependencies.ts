import {join} from 'node:path';
import {parseArgs} from 'node:util';

import {
  CACHE_DIR,
  Repo,
  build,
  load,
  selectByPatterns,
  sync,
} from './dependencies.ts';

const {
  values: {
    force,
    help,
    ['with-lockfile']: withLockfile,
  },
  positionals: patterns,
} = (() => {
  try {
    return parseArgs({
      options: {
        force: {type: 'boolean', short: 'f'},
        help: {type: 'boolean', short: 'h'},
        ['with-lockfile']: {type: 'boolean'},
      },
      allowPositionals: true,
    });
  } catch (err) {
    console.error(err);
    console.log("For more information, try '--help'");
    process.exit(1);
  }
})();

if (force && !withLockfile) {
  console.error('error: --force only applies with --with-lockfile');
  process.exit(1);
}

if (help) {
  console.log(`
Usage: bin/sync-dependencies [--with-lockfile [--force]] [pattern...]

  (no flags)       Mirror mode: rsync each cached repo under
                   .cache/repos into the worktree exactly as it is
                   currently checked out (no fetch, checkout, or
                   build). Use this while iterating on a dependency
                   locally.
  --with-lockfile  Reconcile mode: for each dependency, check out the
                   commit pinned in dependencies.json (fetching only
                   if absent), run its build hook, then rsync. Use
                   this to reproduce the pinned state (eg. after a
                   pull). Repos that are ahead of or diverged from the
                   lockfile are skipped with a warning.
  --force          In reconcile mode, check out the pinned commit even
                   for repos that are ahead of or diverged from the
                   lockfile.

With no patterns, every dependency is synced. Otherwise, only
dependencies matching at least one pattern are synced. Matching is
case-insensitive substring matching against both the dependency id
(eg. "github/wincent/command-t") and its installed path (eg.
"aspects/nvim/files/.config/nvim/pack/bundle/opt/command-t").

Examples:
  bin/sync-dependencies command-t     # just command-t
  bin/sync-dependencies nvim          # every nvim plugin
  bin/sync-dependencies ferret loupe  # ferret and loupe

Anything skipped (or otherwise not brought to its intended state) is
collected and re-printed in a summary at the end, and makes the
command exit non-zero so it is not lost in the output.
    `.trim());
  process.exit(0);
}

type Issue = {level: 'error' | 'warning'; prefix: string; message: string};
const issues: Array<Issue> = [];

function warn(prefix: string, message: string): void {
  console.warn(`warning: [${prefix}] ${message}`);
  issues.push({level: 'warning', prefix, message});
}

function fail(prefix: string, message: string): void {
  console.error(`error: [${prefix}] ${message}`);
  issues.push({level: 'error', prefix, message});
}

const state = load();
const allEntries = Object.entries(state);

const entries = selectByPatterns(
  allEntries,
  patterns,
  ([id, entry]) => ({id, prefix: entry.prefix}),
  'Syncing',
);

if (patterns.length > 0 && entries.length === 0) {
  console.log('No dependencies matched the given pattern(s); nothing to do.');
  process.exit(0);
}

for (const [cacheName, entry] of entries) {
  const {prefix} = entry;
  const cachePath = join(CACHE_DIR, cacheName);
  const repo = new Repo(cachePath);

  if (!withLockfile) {
    // Mirror mode: rsync whatever is currently checked out in the cache.
    if (!repo.exists) {
      warn(prefix, `not synced: no cached repo at ${cacheName}`);
      continue;
    }
    sync(cacheName, prefix);
    continue;
  }

  // Reconcile mode: make the cache (and worktree) match the lockfile.
  const {url, branch, current, build: buildCommand} = entry;

  const preexisting = repo.exists;
  const target = preexisting ? repo : Repo.clone(url, branch, cachePath);

  if (!target.hasCommit(current)) {
    console.log(`  [${prefix}] Fetching pinned commit ${current}...`);
    target.fetch('origin');
  }

  if (!target.hasCommit(current)) {
    fail(
      prefix,
      `pinned commit ${current} not found after fetch; not reconciled`,
    );
    continue;
  }

  const head = target.HEAD;

  if (head !== current) {
    if (preexisting && !force) {
      const dirty = target.isDirty();
      const ahead = head != null && target.isAncestor(current, head);
      const behind = head != null && target.isAncestor(head, current);
      const diverged = !ahead && !behind;

      if (dirty || ahead || diverged) {
        const reason = dirty
          ? 'has uncommitted changes'
          : diverged
          ? 'has diverged from the lockfile'
          : 'is ahead of the lockfile';
        warn(
          prefix,
          `not reconciled: cached repo ${reason} ` +
            `(use --force to check out ${current.substring(0, 7)} anyway)`,
        );
        continue;
      }
    }

    console.log(
      `  [${prefix}] Checking out pinned commit ${current.substring(0, 7)}...`,
    );
    target.checkout(current);
  }

  if (buildCommand) {
    build(cacheName, prefix, buildCommand);
  }

  sync(cacheName, prefix);
}

if (issues.length === 0) {
  console.log('Done.');
} else {
  const errors = issues.filter((issue) => issue.level === 'error');
  const warnings = issues.filter((issue) => issue.level === 'warning');

  console.error('\n' + '='.repeat(80));
  console.error('SYNC SUMMARY');
  console.error('='.repeat(80) + '\n');

  for (const {level, prefix, message} of [...errors, ...warnings]) {
    console.error(`* ${level.toUpperCase().padEnd(7)} [${prefix}] ${message}`);
  }

  const parts: Array<string> = [];
  if (errors.length > 0) {
    parts.push(`${errors.length} ${errors.length === 1 ? 'error' : 'errors'}`);
  }
  if (warnings.length > 0) {
    parts.push(
      `${warnings.length} ${warnings.length === 1 ? 'warning' : 'warnings'}`,
    );
  }

  console.error('\n' + '='.repeat(80));
  console.error(`${parts.join(', ')} (not everything was synced)`);
  console.error('='.repeat(80));

  process.exit(1);
}
