import {mkdirSync} from 'fs';

import {join} from 'path';
import {
  CACHE_DIR,
  Repo,
  getDependenciesList,
  load,
  save,
  sync,
} from './dependencies.ts';

mkdirSync(CACHE_DIR, {recursive: true});

const state = load();
const DEPENDENCIES = getDependenciesList(state);
const changelog: Array<{
  prefix: string;
  cacheName: string;
  previousHead: string;
  currentHead: string;
  log: string;
}> = [];

async function updateDependency({prefix, url, branch}: {
  prefix: string;
  url: string;
  branch: string;
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
