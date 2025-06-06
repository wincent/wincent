import assert from '../../assert.ts';
import stat from '../../fs/stat.ts';
import tempdir from '../../fs/tempdir.ts';
import tempfile from '../../fs/tempfile.ts';
import {expect, test} from '../../test/harness.ts';
import chmod from '../chmod.ts';

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
