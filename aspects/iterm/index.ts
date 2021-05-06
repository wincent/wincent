import {file, path, resource, skip, task, variable} from 'fig';
import assert from 'fig/assert.js';
import stat from 'fig/fs/stat.js';
import stringify from 'fig/stringify.js';

import type {Path} from 'fig';

// iTerm will create some of these on first run, but we specify all here
// for completeness.
task('create directories', async () => {
  for (const directory of [
    '~/Library/Application Support/iTerm2',
    '~/Library/Application Support/iTerm2/DynamicProfiles',
    '~/Library/Application Support/iTerm2/Sources',
  ]) {
    await file({path: directory, state: 'directory'});
  }
});

task('link Dynamic Profiles', async () => {
  const profiles = path.home.join(
    'Library/Application Support/iTerm2/DynamicProfiles'
  );

  for (const src of resource.files('DynamicProfiles/*.json')) {
    await file({
      force: true,
      path: profiles.join(src.basename),
      src,
      state: 'link',
    });
  }
});

task('link sources', async () => {
  const sources = path.home.join('Library/Application Support/iTerm2/Sources');

  for (const src of resource.files('Sources/*.json')) {
    await file({
      force: true,
      path: sources.join(src.basename),
      src,
      state: 'link',
    });
  }
});

task('set up switchable symbolic links', async () => {
  const {retina} = variable.object('iTermDynamicProfiles');

  assert.JSONArray(retina);

  const sources = path.home.join('Library/Application Support/iTerm2/Sources');
  const profiles = path.home.join(
    'Library/Application Support/iTerm2/DynamicProfiles'
  );

  for (const config of retina) {
    assert.JSONObject(config);
    let {src, path: dest} = config;

    src = sources.join(String(src));
    dest = profiles.join(String(dest));

    // We only link these ones if they don't already exist;
    // once created, Hammerspoon manages the links.
    const stats = await stat((dest as Path).expand);

    if (stats === null) {
      await file({
        path: dest,
        src,
        state: 'link',
      });
    } else {
      skip(`path ${stringify(dest)} exists`);
    }
  }
});
