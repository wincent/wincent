import * as assert from 'node:assert';
import {describe, test} from 'node:test';
import {setImmediate} from 'node:timers/promises';

import {log} from '../console.ts';
import runBatch from '../runBatch.ts';

describe('runBatch()', () => {
  test('runs workers concurrently and waits for their items', async (t) => {
    t.mock.method(log, 'notice', async () => {});
    const started = [
      Promise.withResolvers<void>(),
      Promise.withResolvers<void>(),
    ];
    const finished: Array<number> = [];

    await runBatch([0, 1], async (index, batch) => {
      await batch.runItem(`Item ${index}`, async () => {
        started[index].resolve();
        await started[1 - index].promise;
        finished.push(index);
      });
    });

    assert.deepStrictEqual(finished.sort(), [0, 1]);
    await runBatch([], async () => assert.fail('empty batch started a worker'));
  });

  test('drains active items but stops subsequent items and setup work', async (t) => {
    const notice = t.mock.method(log, 'notice', async () => {});
    const started = Promise.withResolvers<void>();
    const failure = new Error('first failure');
    const events: Array<string> = [];

    await assert.rejects(
      runBatch(['fail', 'active', 'setup'], async (item, batch) => {
        if (item === 'fail') {
          await started.promise;
          throw failure;
        } else if (item === 'setup') {
          // Let the failing worker's rejection reach the batch boundary.
          await setImmediate();
          batch.checkpoint();
          events.push('setup continued');
        } else {
          await batch.runItem('active', async () => {
            started.resolve();
            await setImmediate();
            events.push('finished');
          });
          await batch.runItem('not started', async () => {
            events.push('started another item');
          });
        }
      }),
      (error) => error === failure,
    );

    assert.deepStrictEqual(events, ['finished']);
    assert.deepStrictEqual(notice.mock.calls.map(({arguments: args}) => args), [
      ['active'],
    ]);
  });

  test('checks again after logging yields, before invoking the callback', async (t) => {
    t.mock.method(log, 'notice', async () => {
      await setImmediate();
    });
    const failure = new Error('failed while peer was logging');
    let invoked = false;

    await assert.rejects(
      runBatch(['fail', 'waiting'], async (item, batch) => {
        if (item === 'fail') {
          throw failure;
        }
        await batch.runItem('waiting', async () => {
          invoked = true;
        });
      }),
      (error) => error === failure,
    );
    assert.strictEqual(invoked, false);
  });

  for (const failure of [new Error('first failure'), undefined]) {
    test(`preserves the first rejection (${String(failure)}) while draining later failures`, async () => {
      let drained = false;
      const result = await runBatch(['second', 'first'], async (item) => {
        if (item === 'first') {
          throw failure;
        }
        await setImmediate();
        drained = true;
        throw new Error('later failure');
      }).then(
        () => assert.fail('batch should reject'),
        (error) => ({error}),
      );

      assert.strictEqual(result.error, failure);
      assert.strictEqual(drained, true);
    });
  }
});
