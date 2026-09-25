import * as assert from 'node:assert';
import {AsyncLocalStorage} from 'node:async_hooks';

type Queue = {
  items: Array<{
    callback: () => Promise<unknown>;
    resolve: (value: unknown) => void;
    reject: (error: unknown) => void;
  }>;
  tickScheduled: boolean;
};

const queues = new Map<string, Queue>();

/**
 * Not really a mutex, but we present a Mutex-like API to callers. Internally,
 * this is an asynchronous queue with blocking semantics. Our primary use case
 * is to make sure that we (mostly) don't intermix prompts and other console
 * output in confusing ways when `--parallel` is in effect.
 */
export default function lock(
  name: string,
  callback: () => Promise<unknown>,
): Promise<unknown> {
  if (!queues.has(name)) {
    queues.set(name, {items: [], tickScheduled: false});
  }
  const queue = queues.get(name)!;

  return new Promise((resolve, reject) => {
    queue.items.push({
      // The queue's timer may belong to a different caller. Preserve the
      // submitting caller's async context instead of inheriting the timer's.
      callback: AsyncLocalStorage.bind(callback),
      resolve,
      reject,
    });

    if (queue.items.length === 1 && !queue.tickScheduled) {
      // We're the only thing in the queue, proceed immediately.
      queue.tickScheduled = true;
      setTimeout(tick, 0, queue);
    }
  });
}

async function tick(queue: Queue) {
  assert.ok(queue.tickScheduled);
  const next = queue.items[0];
  assert.ok(next);

  try {
    const value = await next.callback();
    next.resolve(value);
  } catch (error) {
    next.reject(error);
  } finally {
    // Keep queue draining in both success and failure case, otherwise the queue
    // stalls.
    queue.items.shift();
    if (queue.items.length) {
      setTimeout(tick, 0, queue);
    } else {
      queue.tickScheduled = false;
    }
  }
}
