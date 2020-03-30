import {relative, sep} from 'path';

import {assertAspect} from '../types/Project';
import getCaller from '../getCaller';
import Context from './Context';
import {default as root} from './root';

export default function task(name: string, callback: () => Promise<void>) {
  const caller = getCaller();

  const ancestors = relative(root, caller).split(sep);

  const aspect =
    ancestors[0] === 'lib' && ancestors[1] === 'aspects' && ancestors[2];

  if (!aspect) {
    throw new Error(`Unable to determine aspect for ${caller}`);
  }

  assertAspect(aspect);
  // TODO: use `caller` to make namespaced task name.

  Context.tasks.register(aspect, callback, name);
}
