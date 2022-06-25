import Context from '../Context.js';
import getCallers from '../getCallers.js';
import getAspectFromCallers from '../getAspectFromCallers.js';
import {assertAspect} from '../types/Project.js';

export default function handler(name: string, callback: () => Promise<void>) {
  const aspect = getAspectFromCallers(getCallers());
  assertAspect(aspect);
  Context.handlers.register(aspect, callback, `${aspect} | ${name}`);
}
