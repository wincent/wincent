import {log} from './console.ts';

type Batch = {
  checkpoint(): void;
  runItem(label: string, callback: () => Promise<unknown>): Promise<void>;
};

/**
 * Stop admitting work after the first failure, but drain active workers before
 * rethrowing it. Checkpoints belong between items, never inside their callbacks.
 */
export default async function runBatch<T>(
  items: Array<T>,
  worker: (item: T, batch: Batch) => Promise<void>,
): Promise<void> {
  const stopped = Symbol('batch stopped');
  // A wrapper distinguishes no failure from `throw undefined`.
  let firstFailure: {error: unknown} | undefined;

  function checkpoint(): void {
    if (firstFailure) {
      throw stopped;
    }
  }

  function recordFailure(error: unknown): void {
    if (error !== stopped) {
      firstFailure ??= {error};
    }
  }

  const batch: Batch = {
    checkpoint,
    async runItem(label, callback) {
      try {
        checkpoint();
        await log.notice(label);
        // Logging yields too; a sibling may have failed in the meantime.
        checkpoint();
        await callback();
      } catch (error) {
        // Stop peers before the rejection propagates through the worker.
        recordFailure(error);
        throw error;
      }
    },
  };

  await Promise.all(items.map(async (item) => {
    try {
      await worker(item, batch);
    } catch (error) {
      // Setup can fail without going through runItem().
      recordFailure(error);
    }
  }));

  if (firstFailure) {
    throw firstFailure.error;
  }
}
