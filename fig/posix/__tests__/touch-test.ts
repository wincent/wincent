import * as assert from 'node:assert';
import {join} from 'node:path';
import {test} from 'node:test';

import stat from '../../fs/stat.ts';
import tempdir from '../../fs/tempdir.ts';
import touch from '../touch.ts';

test('touch() creates a file', async () => {
  const path = await tempdir('rm-test');

  let stats = await stat(path);

  assert.ok(stats !== null);
  assert.ok(!(stats instanceof Error));

  const file = join(path, 'file');

  await touch(file);

  stats = await stat(file);

  assert.ok(stats !== null);
  assert.ok(!(stats instanceof Error));

  assert.strictEqual(stats.type, 'file');
});
