import {mkdirSync} from 'fs';

import {join} from 'path';
import {
  CACHE_DIR,
  Repo,
  build as runBuild,
  getDependenciesList,
  load,
  save,
  sync,
} from './dependencies.ts';

function parseArgs(argv: Array<string>): {patterns: Array<string>} {
  const patterns: Array<string> = [];

  for (const arg of argv) {
    if (arg === '-h' || arg === '--help') {
      console.log(
        [
          'Usage: bin/update-dependencies [pattern...]',
          '',
          'Update cached dependencies (fetch, build, sync), recording any',
          'changes in dependencies.json.',
          '',
          'With no patterns, every dependency is updated. Otherwise, only',
          'dependencies matching at least one pattern are updated. Matching is',
          'case-insensitive substring matching against both the dependency id',
          '(eg. "github/wincent/command-t") and its installed path (eg.',
          '"aspects/nvim/files/.config/nvim/pack/bundle/opt/command-t").',
          '',
          'Examples:',
          '  bin/update-dependencies command-t     # just command-t',
          '  bin/update-dependencies nvim          # every nvim plugin',
          '  bin/update-dependencies ferret loupe  # ferret and loupe',
        ].join('\n'),
      );
      process.exit(0);
    } else if (arg.startsWith('-')) {
      console.error(`error: unknown option: ${arg}`);
      process.exit(1);
    } else {
      patterns.push(arg);
    }
  }

  return {patterns};
}

function matchesPattern(
  dependency: {id: string; prefix: string},
  pattern: string,
): boolean {
  const needle = pattern.toLowerCase();
  return (
    dependency.id.toLowerCase().includes(needle) ||
    dependency.prefix.toLowerCase().includes(needle)
  );
}

const {patterns} = parseArgs(process.argv.slice(2));

mkdirSync(CACHE_DIR, {recursive: true});

const state = load();
const ALL_DEPENDENCIES = getDependenciesList(state);

let DEPENDENCIES = ALL_DEPENDENCIES;

if (patterns.length > 0) {
  for (const pattern of patterns) {
    if (
      !ALL_DEPENDENCIES.some((dependency) =>
        matchesPattern(dependency, pattern)
      )
    ) {
      console.warn(`warning: no dependencies matched pattern: ${pattern}`);
    }
  }

  DEPENDENCIES = ALL_DEPENDENCIES.filter((dependency) =>
    patterns.some((pattern) => matchesPattern(dependency, pattern))
  );

  if (DEPENDENCIES.length === 0) {
    console.log('No dependencies matched the given pattern(s); nothing to do.');
    process.exit(0);
  }

  console.log(
    `Updating ${DEPENDENCIES.length} of ${ALL_DEPENDENCIES.length} ` +
      `${ALL_DEPENDENCIES.length === 1 ? 'dependency' : 'dependencies'} ` +
      `matching: ${patterns.join(', ')}\n`,
  );
}

const changelog: Array<{
  prefix: string;
  cacheName: string;
  previousHead: string;
  currentHead: string;
  log: string;
}> = [];

async function updateDependency({prefix, url, branch, build}: {
  prefix: string;
  url: string;
  branch: string;
  build?: string;
}) {
  const parsedUrl = new URL(url);
  const pathParts = parsedUrl.pathname.replace(/\.git$/, '').split('/').filter(
    Boolean,
  );
  const host = parsedUrl.hostname.split('.')[0];
  const cacheName = join(host, ...pathParts);
  const cachePath = join(CACHE_DIR, cacheName);
  let repo = new Repo(cachePath);

  console.log(`Processing ${prefix}...`);

  const previousState = state[cacheName] || {};
  const previousHead = previousState.current || null;

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
      changelog.push({
        prefix,
        cacheName,
        previousHead,
        currentHead,
        log,
      });
    }
  } else {
    state[cacheName] = previousState;
  }

  if (build) {
    runBuild(cacheName, prefix, build);
  }

  sync(cacheName, prefix);

  console.log(`  [${prefix}] Done.\n`);
}

const BATCH_SIZE = 5;
for (let i = 0; i < DEPENDENCIES.length; i += BATCH_SIZE) {
  const batch = DEPENDENCIES.slice(i, i + BATCH_SIZE);
  await Promise.all(batch.map(updateDependency));
}

save(state);

console.log('All dependencies updated successfully.');

if (changelog.length > 0) {
  console.log('\n' + '='.repeat(80));
  console.log('CHANGELOG');
  console.log('='.repeat(80) + '\n');

  for (const entry of changelog) {
    const from = entry.previousHead.substring(0, 7);
    const to = entry.currentHead.substring(0, 7);
    const lines = entry.log.split('\n');
    console.log(`* ${entry.prefix} ${from}..${to} (${lines.length}):`);
    console.log();
    const indentedLog = lines.map((line) => `  ${line}`).join('\n');
    console.log(indentedLog);
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
