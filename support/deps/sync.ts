import {join} from 'node:path';
import {parseArgs} from 'node:util';

import {
  CACHE_DIR,
  Repo,
  build,
  classifyCache,
  load,
  shortHash,
  sync,
} from '../dependencies.ts';
import {Issues, PATTERN_HELP, bail, select} from './shared.ts';

const HELP = `
Usage: bin/deps sync [--with-lockfile [--force]] [pattern...]

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

Run \`bin/deps status\` first to preview what either mode would do.

${PATTERN_HELP}

Examples:
  bin/deps sync command-t     # just command-t
  bin/deps sync nvim          # every nvim plugin
  bin/deps sync ferret loupe  # ferret and loupe

Anything skipped (or otherwise not brought to its intended state) is
collected and re-printed in a summary at the end, and makes the
command exit non-zero so it is not lost in the output.
`.trim();

export function run(args: Array<string>): void {
  const {
    values: {force, help, ['with-lockfile']: withLockfile},
    positionals: patterns,
  } = (() => {
    try {
      return parseArgs({
        args,
        options: {
          force: {type: 'boolean', short: 'f'},
          help: {type: 'boolean', short: 'h'},
          ['with-lockfile']: {type: 'boolean'},
        },
        allowPositionals: true,
      });
    } catch (err) {
      return bail(err);
    }
  })();

  if (help) {
    console.log(HELP);
    return;
  }

  if (force && !withLockfile) {
    console.error('error: --force only applies with --with-lockfile');
    process.exit(1);
  }

  const issues = new Issues();
  const entries = select(
    Object.entries(load()),
    patterns,
    ([id, entry]) => ({id, prefix: entry.prefix}),
    'Syncing',
  );

  for (const [cacheName, entry] of entries) {
    const {branch, build: buildCommand, current: pinned, prefix, url} = entry;
    const cachePath = join(CACHE_DIR, cacheName);
    const repo = new Repo(cachePath);

    if (!withLockfile) {
      // Mirror mode: rsync whatever is currently checked out in the cache.
      if (!repo.exists) {
        issues.warn(prefix, `not synced: no cached repo at ${cacheName}`);
        continue;
      }
      sync(cacheName, prefix);
      continue;
    }

    // Reconcile mode: make the cache (and worktree) match the lockfile.
    const preexisting = repo.exists;
    const target = preexisting ? repo : Repo.clone(url, branch, cachePath);

    let {state} = classifyCache(target, pinned);

    if (state === 'absent') {
      console.log(`  [${prefix}] Fetching pinned commit ${pinned}...`);
      target.fetch('origin');
      ({state} = classifyCache(target, pinned));
    }

    if (state === 'absent') {
      issues.fail(
        prefix,
        `pinned commit ${pinned} not found after fetch; not reconciled`,
      );
      continue;
    }

    if (state !== 'clean') {
      const dirty = target.isDirty();

      if (preexisting && !force && (dirty || state !== 'behind')) {
        const reason = dirty
          ? 'has uncommitted changes'
          : state === 'ahead'
          ? 'is ahead of the lockfile'
          : state === 'diverged'
          ? 'has diverged from the lockfile'
          : `is in an unexpected state (${state})`;
        issues.warn(
          prefix,
          `not reconciled: cached repo ${reason} ` +
            `(use --force to check out ${shortHash(pinned)} anyway)`,
        );
        continue;
      }

      console.log(
        `  [${prefix}] Checking out pinned commit ${shortHash(pinned)}...`,
      );
      target.checkout(pinned);
    }

    if (buildCommand) {
      build(cacheName, prefix, buildCommand);
    }

    sync(cacheName, prefix);
  }

  if (issues.length === 0) {
    console.log('Done.');
  } else {
    issues.report('SYNC SUMMARY', 'not everything was synced');
  }
}
