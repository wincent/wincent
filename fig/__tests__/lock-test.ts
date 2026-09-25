import * as assert from 'node:assert';
import {AsyncLocalStorage} from 'node:async_hooks';
import {describe, test} from 'node:test';

import lock from '../lock.ts';

describe('lock()', () => {
  test('runs a callback and returns its value', async () => {
    assert.strictEqual(await lock('runs', async () => 'value'), 'value');
  });

  test('runs callbacks one at a time, in order', async () => {
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

  test("preserves each caller's async context across queue entries", async () => {
    const scope = new AsyncLocalStorage<string>();
    const events: Array<string | undefined> = [];

    const promises = ['a', 'b'].map((name) =>
      scope.run(name, () =>
        lock('contexts', async () => {
          events.push(scope.getStore());
          await new Promise((resolve) => setTimeout(resolve, 0));
          events.push(scope.getStore());
        }))
    );
    promises.push(lock('contexts', async () => {
      events.push(scope.getStore());
    }));

    await Promise.all(promises);
    assert.deepStrictEqual(events, ['a', 'a', 'b', 'b', undefined]);
    assert.strictEqual(scope.getStore(), undefined);
  });

  test("preserves the next caller's context after rejection", async () => {
    const scope = new AsyncLocalStorage<string>();
    const rejected = scope.run(
      'first',
      () =>
        lock('rejected-context', async () => {
          throw new Error('bang');
        }),
    );
    const queued = scope.run(
      'second',
      () => lock('rejected-context', async () => scope.getStore()),
    );

    await assert.rejects(rejected, /bang/);
    assert.strictEqual(await queued, 'second');
    assert.strictEqual(scope.getStore(), undefined);
  });

  test('propagates a rejection to the caller', async () => {
    await assert.rejects(
      lock('rejects', async () => {
        throw new Error('bang');
      }),
      /bang/,
    );
  });

  test('keeps draining the queue after a rejection', async () => {
    const rejected = lock('drains', async () => {
      throw new Error('bang');
    });

    const queued = lock('drains', async () => 'after');

    await assert.rejects(rejected, /bang/);

    assert.strictEqual(await queued, 'after');
  });

  test('accepts new work after a rejection empties the queue', async () => {
    await assert.rejects(
      lock('accepts', async () => {
        throw new Error('bang');
      }),
      /bang/,
    );

    assert.strictEqual(await lock('accepts', async () => 'later'), 'later');
  });
});
