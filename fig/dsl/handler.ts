import Context from '../Context.js';
import getCaller from '../getCaller.js';
import getAspectFromCaller from '../getAspectFromCaller.js';

export default function handler(name: string, callback: () => Promise<void>) {
  const caller = getCaller();

  const aspect = getAspectFromCaller(caller);

  Context.handlers.register(aspect, callback, `${aspect} | ${name}`);
}
