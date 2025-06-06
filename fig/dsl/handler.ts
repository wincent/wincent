import Context from '../Context.ts';
import getAspectFromCallers from '../getAspectFromCallers.ts';
import getCallers from '../getCallers.ts';
import {assertAspect} from '../types/Project.ts';

export default function handler(name: string, callback: () => Promise<void>) {
  const aspect = getAspectFromCallers(getCallers());
  assertAspect(aspect);
  Context.handlers.register(aspect, callback, `${aspect} | ${name}`);
}
