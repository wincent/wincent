import assert from 'node:assert';
import {test} from 'node:test';

import figAssert from '../../assert.ts';
import stat from '../../fs/stat.ts';
import tempdir from '../../fs/tempdir.ts';
import tempfile from '../../fs/tempfile.ts';
import chmod from '../chmod.ts';

test('chmod() changes the mode of a file', async () => {
  const path = await tempfile('chmod-test');

  let stats = await stat(path);

  figAssert(stats !== null);
  figAssert(!(stats instanceof Error));
  figAssert(stats.mode !== '0600');

  const result = await chmod('0600', path);

  assert.strictEqual(result, null);

  stats = await stat(path);

  figAssert(stats !== null);
  figAssert(!(stats instanceof Error));

  assert.strictEqual(stats.mode, '0600');
});

test('chmod() changes the mode of a directory', async () => {
  const path = await tempdir('chmod-test');

  let stats = await stat(path);

  figAssert(stats !== null);
  figAssert(!(stats instanceof Error));
  figAssert(stats.mode !== '0700');

  const result = await chmod('0700', path);

  assert.strictEqual(result, null);

  stats = await stat(path);

  figAssert(stats !== null);
  figAssert(!(stats instanceof Error));

  assert.strictEqual(stats.mode, '0700');
});
