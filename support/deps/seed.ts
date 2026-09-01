import {mkdirSync} from 'node:fs';
import {join} from 'node:path';
import {parseArgs} from 'node:util';

import {CACHE_DIR, Repo, load} from '../dependencies.ts';
import {PATTERN_HELP, bail, select} from './shared.ts';

const HELP = `
Usage: bin/deps seed [pattern...]

Clone any dependency that is not yet present under .cache/repos, and
stop. Dependencies that are already cloned are left alone, whatever
state they are in.

This is what \`./install\` runs to populate a fresh checkout's cache.
Unlike \`bin/deps sync --with-lockfile\`, it does not check out pinned
commits or touch the worktree.

${PATTERN_HELP}
`.trim();

export function run(args: Array<string>): void {
  const {
    values: {help},
    positionals: patterns,
  } = (() => {
    try {
      return parseArgs({
        args,
        options: {help: {type: 'boolean', short: 'h'}},
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

  mkdirSync(CACHE_DIR, {recursive: true});

  const entries = select(
    Object.entries(load()),
    patterns,
    ([id, entry]) => ({id, prefix: entry.prefix}),
    'Seeding',
  );

  for (const [cacheName, {branch, prefix, url}] of entries) {
    const cachePath = join(CACHE_DIR, cacheName);

    if (new Repo(cachePath).exists) {
      console.log(`Skipping ${prefix} (already cloned)`);
      continue;
    }

    console.log(`Cloning ${prefix}...`);
    Repo.clone(url, branch, cachePath);
  }

  console.log('Done.');
}
