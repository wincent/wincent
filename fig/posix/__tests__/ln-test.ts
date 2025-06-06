import {join} from 'node:path';

import assert from '../../assert.ts';
import stat from '../../fs/stat.ts';
import tempdir from '../../fs/tempdir.ts';
import {expect, test} from '../../test/harness.ts';
import ln from '../ln.ts';
import touch from '../touch.ts';

test('ln() links a file', async () => {
  const base = await tempdir('ln-test');

  const source = join(base, 'source.txt');

  const target = join(base, 'link.txt');

  await touch(source);

  const result = await ln(source, target);

  expect(result).toBe(null);

  const stats = await stat(target);
  assert(!(stats instanceof Error));

  assert(stats !== null);

  expect(stats.type).toBe('link');
  expect(stats.target).toBe(source);
});

test('ln() with `{force: true}` overwrites if necessary', async () => {
  const base = await tempdir('ln-test');

  const source = join(base, 'source.txt');

  const target = join(base, 'link.txt');

  await touch(source);
  await touch(target);

  const result = await ln(source, target, {force: true});

  expect(result).toBe(null);

  const stats = await stat(target);
  assert(!(stats instanceof Error));

  assert(stats !== null);

  expect(stats.type).toBe('link');
  expect(stats.target).toBe(source);
});

test('ln() can create links to non-existent files', async () => {
  // Just link `ln` can...
  const base = await tempdir('ln-test');

  const source = join(base, 'source.txt');

  const target = join(base, 'link.txt');

  const result = await ln(source, target);

  expect(result).toBe(null);

  const stats = await stat(target);
  assert(!(stats instanceof Error));

  assert(stats !== null);

  expect(stats.type).toBe('link');
  expect(stats.target).toBe(source);
});
