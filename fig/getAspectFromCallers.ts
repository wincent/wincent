import {relative, sep} from 'path';
import * as url from 'url';

import {assertAspect} from './types/Project.js';
import {default as root} from './dsl/root.js';

import type {Aspect} from './types/Project.js';

export default function getAspectFromCallers(
  callers: Array<string>
): Aspect | null {
  for (const caller of callers) {
    const path = url.fileURLToPath(caller);
    const ancestors = relative(root, path).split(sep);
    const aspect =
      ancestors[0] === 'lib' && ancestors[1] === 'aspects' && ancestors[2];

    if (aspect) {
      assertAspect(aspect);
      return aspect;
    }
  }
  return null;
}
