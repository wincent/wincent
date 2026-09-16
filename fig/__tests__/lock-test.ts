import * as assert from 'node:assert';
import {test} from 'node:test';

import lock from '../lock.ts';

test('lock() runs a callback and returns its value', async () => {
  assert.strictEqual(await lock('runs', async () => 'value'), 'value');
});

test('lock() runs callbacks one at a time, in order', async () => {
  const events: Array<string> = [];

  const promises = ['a', 'b', 'c'].map((name) => {
    return lock('order', async () => {
      events.push(`start ${name}`);
      await new Promise((resolve) => setTimeout(resolve, 1));
      events.push(`end ${name}`);
    });
  });

  await Promise.all(promises);

  assert.deepStrictEqual(events, [
    'start a',
    'end a',
    'start b',
    'end b',
    'start c',
    'end c',
  ]);
});

test('lock() propagates a rejection to the caller', async () => {
  await assert.rejects(
    lock('rejects', async () => {
      throw new Error('bang');
    }),
    /bang/,
  );
});

test('lock() keeps draining the queue after a rejection', async () => {
  const rejected = lock('drains', async () => {
    throw new Error('bang');
  });

  const queued = lock('drains', async () => 'after');

  await assert.rejects(rejected, /bang/);

  assert.strictEqual(await queued, 'after');
});

test('lock() accepts new work after a rejection empties the queue', async () => {
  await assert.rejects(
    lock('accepts', async () => {
      throw new Error('bang');
    }),
    /bang/,
  );

  assert.strictEqual(await lock('accepts', async () => 'later'), 'later');
});
