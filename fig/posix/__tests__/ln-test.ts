import * as assert from 'node:assert';
import {join} from 'node:path';
import {test} from 'node:test';

import stat from '../../fs/stat.ts';
import tempdir from '../../fs/tempdir.ts';
import ln from '../ln.ts';
import touch from '../touch.ts';

test('ln() links a file', async () => {
  const base = await tempdir('ln-test');

  const source = join(base, 'source.txt');

  const target = join(base, 'link.txt');

  await touch(source);

  const result = await ln(source, target);

  assert.strictEqual(result, null);

  const stats = await stat(target);
  assert.ok(!(stats instanceof Error));

  assert.ok(stats !== null);

  assert.strictEqual(stats.type, 'link');
  assert.strictEqual(stats.target, source);
});

test('ln() with `{force: true}` overwrites if necessary', async () => {
  const base = await tempdir('ln-test');

  const source = join(base, 'source.txt');

  const target = join(base, 'link.txt');

  await touch(source);
  await touch(target);

  const result = await ln(source, target, {force: true});

  assert.strictEqual(result, null);

  const stats = await stat(target);
  assert.ok(!(stats instanceof Error));

  assert.ok(stats !== null);

  assert.strictEqual(stats.type, 'link');
  assert.strictEqual(stats.target, source);
});

test('ln() can create links to non-existent files', async () => {
  // Just link `ln` can...
  const base = await tempdir('ln-test');

  const source = join(base, 'source.txt');

  const target = join(base, 'link.txt');

  const result = await ln(source, target);

  assert.strictEqual(result, null);

  const stats = await stat(target);
  assert.ok(!(stats instanceof Error));

  assert.ok(stats !== null);

  assert.strictEqual(stats.type, 'link');
  assert.strictEqual(stats.target, source);
});
