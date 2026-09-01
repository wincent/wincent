import {mkdirSync} from 'node:fs';
import {join} from 'node:path';
import {parseArgs} from 'node:util';

import {CACHE_DIR, Repo, classify, load} from '../dependencies.ts';
import {Issues, PATTERN_HELP, bail, batch, select} from './shared.ts';

const HELP = `
Usage: bin/deps fetch [pattern...]

Update the remote-tracking refs of each cached repo (cloning any that
are missing), then stop. Nothing else is touched: not the checkouts
under .cache/repos, not dependencies.json, and not the worktree.

This is the read-only half of \`bin/deps update\`, split out so that
you can preview upstream changes before taking them:

  bin/deps fetch
  bin/deps status   # now the "Remote" column is fresh
  bin/deps update   # if you like what you see

Note that \`bin/deps update\` fetches too, so this is never a
prerequisite, only a preview.

${PATTERN_HELP}

Examples:
  bin/deps fetch command-t     # just command-t
  bin/deps fetch nvim          # every nvim plugin
`.trim();

const BATCH_SIZE = 5;

export async function run(args: Array<string>): Promise<void> {
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

  const state = load();
  const entries = select(
    Object.entries(state),
    patterns,
    ([id, entry]) => ({id, prefix: entry.prefix}),
    'Fetching',
  );

  const issues = new Issues();

  await batch(entries, BATCH_SIZE, async ([id, {branch, prefix, url}]) => {
    const cachePath = join(CACHE_DIR, id);
    const repo = new Repo(cachePath);

    try {
      if (repo.exists) {
        console.log(`  [${prefix}] Fetching...`);
        repo.fetch('origin');
      } else {
        console.log(`  [${prefix}] Cloning to cache...`);
        Repo.clone(url, branch, cachePath);
      }
    } catch (err) {
      issues.fail(
        prefix,
        `not fetched: ${err instanceof Error ? err.message : err}`,
      );
    }
  });

  // Re-classify (cheaply, skipping the worktree comparison) purely to say how
  // much is now waiting; `bin/deps status` remains the place for detail.
  const statuses = entries.map(([id, entry]) =>
    classify(id, entry, {worktree: false})
  );
  const available = statuses.filter(({remote}) => remote === 'available');
  const rewound = statuses.filter(({remote}) => remote === 'rewound');

  console.log();

  if (available.length === 0) {
    console.log('Fetched; no upstream changes available.');
  } else {
    const commits = available.reduce((sum, {pending}) => sum + pending, 0);
    console.log(
      `Fetched; ${commits} ${
        commits === 1 ? 'commit' : 'commits'
      } available across ${available.length} ${
        available.length === 1 ? 'dependency' : 'dependencies'
      }.`,
    );
  }

  if (rewound.length > 0) {
    console.log(
      `${rewound.length} ${
        rewound.length === 1 ? 'dependency no' : 'dependencies no'
      } longer contain the pinned commit upstream.`,
    );
  }

  console.log('Run `bin/deps status` for details.');

  issues.report('FETCH SUMMARY', 'not everything was fetched');
}
