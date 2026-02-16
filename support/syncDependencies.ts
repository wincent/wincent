import {existsSync} from 'fs';
import {join} from 'path';

import {CACHE_DIR, load, sync} from './dependencies.ts';

const state = load();

for (const [cacheName, {prefix}] of Object.entries(state)) {
  const cachePath = join(CACHE_DIR, cacheName);

  if (!existsSync(join(cachePath, '.git'))) {
    console.log(`Skipping ${prefix} (no cached repo at ${cacheName})`);
    continue;
  }

  sync(cacheName, prefix);
}

console.log('Done.');
