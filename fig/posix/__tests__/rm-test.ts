import assert from 'node:assert';
import {join} from 'node:path';
import {test} from 'node:test';

import figAssert from '../../assert.ts';
import stat from '../../fs/stat.ts';
import tempdir from '../../fs/tempdir.ts';
import tempfile from '../../fs/tempfile.ts';
import chmod from '../chmod.ts';
import rm from '../rm.ts';
import touch from '../touch.ts';

test('rm() removes a file', async () => {
  const path = await tempfile('rm-test');

  let stats = await stat(path);

  figAssert(stats !== null);
  figAssert(!(stats instanceof Error));

  const result = await rm(path);

  assert.strictEqual(result, null);

  stats = await stat(path);

  assert.strictEqual(stats, null);
});

test('rm() removes a file, ignoring permissions', async () => {
  const path = await tempfile('rm-test');

  let result = await chmod('0400', path);

  let stats = await stat(path);

  figAssert(stats !== null);
  figAssert(!(stats instanceof Error));

  assert.strictEqual(stats.mode, '0400');

  result = await rm(path);

  assert.strictEqual(result, null);

  stats = await stat(path);

  assert.strictEqual(stats, null);
});

test('rm() with `recurse: true` removes an empty directory', async () => {
  const path = await tempdir('rm-test');

  let stats = await stat(path);

  figAssert(stats !== null);
  figAssert(!(stats instanceof Error));

  const result = await rm(path, {recurse: true});

  assert.strictEqual(result, null);

  stats = await stat(path);

  assert.strictEqual(stats, null);
});

test('rm() with `recurse: true` removes a non-empty directory', async () => {
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

  const result = await rm(path, {recurse: true});

  assert.strictEqual(result, null);

  stats = await stat(path);

  assert.strictEqual(stats, null);
});

test('rm() without `recurse: true` does not remove a directory', async () => {
  const path = await tempdir('rm-test');

  let stats = await stat(path);

  figAssert(stats !== null);
  figAssert(!(stats instanceof Error));

  const result = await rm(path);

  assert.strictEqual(result instanceof Error, true);

  stats = await stat(path);

  figAssert(stats !== null);
  figAssert(!(stats instanceof Error));
});
