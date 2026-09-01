import {mkdirSync} from 'node:fs';
import {join} from 'node:path';
import {parseArgs} from 'node:util';

import type {Entry} from '../dependencies.ts';
import {
  CACHE_DIR,
  Repo,
  build as runBuild,
  load,
  save,
  shortHash,
  sync,
} from '../dependencies.ts';
import {Issues, PATTERN_HELP, bail, batch, select} from './shared.ts';

const HELP = `
Usage: bin/deps update [pattern...]

Update cached dependencies (fetch, build, sync), recording any
changes in dependencies.json.

To preview what this would do without applying it, run \`bin/deps
fetch\` followed by \`bin/deps status\`. Note that this command fetches
too, so a preview is never a prerequisite; if upstream moves in
between, this command will pick that up as well.

${PATTERN_HELP}

Examples:
  bin/deps update command-t     # just command-t
  bin/deps update nvim          # every nvim plugin
  bin/deps update ferret loupe  # ferret and loupe

Dependencies that fail to update are collected and re-printed in a
summary at the end, and make the command exit non-zero. Dependencies
that succeeded are still recorded in dependencies.json.
`.trim();

const BATCH_SIZE = 5;

type ChangelogEntry = {
  prefix: string;
  previousHead: string;
  currentHead: string;
  log: string;
};

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
  const issues = new Issues();
  const changelog: Array<ChangelogEntry> = [];

  const entries = select(
    Object.entries(state),
    patterns,
    ([id, entry]) => ({id, prefix: entry.prefix}),
    'Updating',
  );

  async function updateDependency([cacheName, entry]: [string, Entry]) {
    const {branch, build, prefix, url} = entry;
    const cachePath = join(CACHE_DIR, cacheName);
    let repo = new Repo(cachePath);

    console.log(`Processing ${prefix}...`);

    const previousHead = entry.current || null;

    if (repo.exists) {
      console.log(`  [${prefix}] Updating cached repo...`);
      repo.fetch('origin');
      repo.checkout(branch);
      repo.merge(`origin/${branch}`);
    } else {
      console.log(`  [${prefix}] Cloning to cache...`);
      repo = Repo.clone(url, branch, cachePath);
    }

    const currentHead = repo.HEAD;

    if (previousHead && currentHead && previousHead !== currentHead) {
      state[cacheName] = {
        prefix,
        url,
        branch,
        previous: previousHead,
        current: currentHead,
        build,
      };

      const log = repo.log(previousHead, currentHead);
      if (log) {
        changelog.push({currentHead, log, prefix, previousHead});
      }
    }

    if (build) {
      runBuild(cacheName, prefix, build);
    }

    sync(cacheName, prefix);

    console.log(`  [${prefix}] Done.\n`);
  }

  await batch(entries, BATCH_SIZE, async (entry) => {
    try {
      await updateDependency(entry);
    } catch (err) {
      // Keep going: one broken dependency should not cost us the progress
      // (and the lockfile updates) of the other sixty-nine.
      issues.fail(
        entry[1].prefix,
        `not updated: ${err instanceof Error ? err.message : err}`,
      );
    }
  });

  save(state);

  if (changelog.length > 0) {
    console.log('\n' + '='.repeat(80));
    console.log('CHANGELOG');
    console.log('='.repeat(80) + '\n');

    for (const entry of changelog) {
      const lines = entry.log.split('\n');
      console.log(
        `* ${entry.prefix} ${shortHash(entry.previousHead)}..${
          shortHash(entry.currentHead)
        } (${lines.length}):`,
      );
      console.log();
      console.log(lines.map((line) => `  ${line}`).join('\n'));
      console.log();
    }

    console.log('='.repeat(80));
    console.log(
      `${changelog.length} ${
        changelog.length === 1 ? 'dependency' : 'dependencies'
      } updated`,
    );
    console.log('='.repeat(80));
  } else {
    console.log('\nNo changes detected in any dependencies.');
  }

  issues.report('UPDATE SUMMARY', 'not everything was updated');
}
