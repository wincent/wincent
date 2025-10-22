import assert from 'node:assert';
import {join} from 'node:path';
import {test} from 'node:test';

import figAssert from '../../assert.ts';
import stat from '../../fs/stat.ts';
import tempdir from '../../fs/tempdir.ts';
import touch from '../touch.ts';

test('touch() creates a file', async () => {
  const path = await tempdir('rm-test');

  let stats = await stat(path);

  figAssert(stats !== null);
  figAssert(!(stats instanceof Error));

  const file = join(path, 'file');

  await touch(file);

  stats = await stat(file);

  figAssert(stats !== null);
  figAssert(!(stats instanceof Error));

  assert.strictEqual(stats.type, 'file');
});
