import Context from '../Context.js';
import getCallers from '../getCallers.js';
import getAspectFromCallers from '../getAspectFromCallers.js';
import {assertAspect} from '../types/Project.js';
import skip from './skip.js';

type Callback = () => Promise<void>;
type Predicate = () => true | string;

/**
 * Registers a task with `name` that will execute `callback`, but only if
 * `predicate` returns `true`. If the `predicate` does _not_ return `true`,
 * then it must return a string that indicates why the task execution should be
 * skipped.
 */
export default function task(
  name: string,
  predicate: Predicate,
  callback: Callback
): void;

/**
 * Registers a task with `name` that will execute `callback` unconditionally.
 */
export default function task(name: string, callback: Callback): void;

export default function task(
  name: string,
  callbackOrPredicate: Callback | Predicate,
  callback?: Callback
) {
  const aspect = getAspectFromCallers(getCallers());
  assertAspect(aspect);

  Context.tasks.register(
    aspect,
    async () => {
      const result = await callbackOrPredicate();
      if (callback) {
        // Overload 1: `result` should be a Predicate return value.
        if (result === true) {
          await callback();
        } else if (result) {
          await skip(result);
        } else {
          throw new Error(
            'task(): expected predicate to return `true` or a string'
          );
        }
      } else {
        // Overload 2: `result` should be a Callback return value (void).
        if (result !== undefined) {
          throw new Error('task(): expected callback to return nothing');
        }
      }
    },
    `${aspect} | ${name}`
  );
}
