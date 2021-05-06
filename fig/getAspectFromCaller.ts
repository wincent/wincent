import {relative, sep} from 'path';
import * as url from 'url';

import {assertAspect} from './types/Project.js';
import {default as root} from './dsl/root.js';

import type {Aspect} from './types/Project.js';

export default function getAspectFromCaller(caller: string): Aspect {
  const path = url.fileURLToPath(caller);

  const ancestors = relative(root, path).split(sep);

  const aspect =
    ancestors[0] === 'lib' && ancestors[1] === 'aspects' && ancestors[2];

  if (!aspect) {
    throw new Error(`Unable to determine aspect for ${caller}`);
  }

  assertAspect(aspect);

  return aspect;
}
