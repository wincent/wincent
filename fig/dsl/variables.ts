import Context from '../Context.ts';
import getAspectFromCallers from '../getAspectFromCallers.ts';
import getCallers from '../getCallers.ts';
import {assertAspect} from '../types/Project.ts';

/**
 * Register a callback to dynamically contribute variables when an aspect is
 * running (useful for values that cannot be determined statically ahead of time
 * and stored in JSON).
 */
export default function variables(callback: (v: Variables) => Variables) {
  const aspect = getAspectFromCallers(getCallers());
  assertAspect(aspect);
  Context.variables.registerVariablesCallback(aspect, callback);
}
