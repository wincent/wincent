import {mkdirSync} from 'fs';
import {join} from 'path';

import {CACHE_DIR, Repo, load} from './dependencies.ts';

mkdirSync(CACHE_DIR, {recursive: true});

const state = load();

for (const [cacheName, {prefix, url, branch}] of Object.entries(state)) {
  const cachePath = join(CACHE_DIR, cacheName);
  const repo = new Repo(cachePath);

  if (repo.exists) {
    console.log(`Skipping ${prefix} (already cloned)`);
    continue;
  }

  console.log(`Cloning ${prefix}...`);
  Repo.clone(url, branch, cachePath);
}

console.log('Done.');
