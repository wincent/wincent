import {join} from 'node:path';

import assert from '../../assert.ts';
import stat from '../../fs/stat.ts';
import tempdir from '../../fs/tempdir.ts';
import {expect, test} from '../../test/harness.ts';
import touch from '../touch.ts';

test('touch() creates a file', async () => {
  const path = await tempdir('rm-test');

  let stats = await stat(path);

  assert(stats !== null);
  assert(!(stats instanceof Error));

  const file = join(path, 'file');

  await touch(file);

  stats = await stat(file);

  assert(stats !== null);
  assert(!(stats instanceof Error));

  expect(stats.type).toBe('file');
});
