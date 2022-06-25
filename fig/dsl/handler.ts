import Context from '../Context.js';
import getCallers from '../getCallers.js';
import getAspectFromCallers from '../getAspectFromCallers.js';

export default function handler(name: string, callback: () => Promise<void>) {
  const aspect = getAspectFromCallers(getCallers());

  Context.handlers.register(aspect, callback, `${aspect} | ${name}`);
}
