import assert from '../../assert.js';
import stat from '../../fs/stat.js';
import tempdir from '../../fs/tempdir.js';
import tempfile from '../../fs/tempfile.js';
import {expect, test} from '../../test/harness.js';
import chmod from '../chmod.js';

test('chmod() changes the mode of a file', async () => {
  const path = await tempfile('chmod-test');

  let stats = await stat(path);

  assert(stats !== null);
  assert(!(stats instanceof Error));
  assert(stats.mode !== '0600');

  const result = await chmod('0600', path);

  expect(result).toBe(null);

  stats = await stat(path);

  assert(stats !== null);
  assert(!(stats instanceof Error));

  expect(stats.mode).toBe('0600');
});

test('chmod() changes the mode of a directory', async () => {
  const path = await tempdir('chmod-test');

  let stats = await stat(path);

  assert(stats !== null);
  assert(!(stats instanceof Error));
  assert(stats.mode !== '0700');

  const result = await chmod('0700', path);

  expect(result).toBe(null);

  stats = await stat(path);

  assert(stats !== null);
  assert(!(stats instanceof Error));

  expect(stats.mode).toBe('0700');
});
