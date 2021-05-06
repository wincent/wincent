import Context from '../Context.js';
import getCaller from '../getCaller.js';
import getAspectFromCaller from '../getAspectFromCaller.js';

/**
 * Register a callback to dynamically contribute variables when an aspect is
 * running (useful for values that cannot be determined statically ahead of time
 * and stored in JSON).
 */
export default function variables(callback: (v: Variables) => Variables) {
  const caller = getCaller();

  const aspect = getAspectFromCaller(caller);

  Context.variables.register(aspect, callback);
}
