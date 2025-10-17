import {relative, sep} from 'node:path';
import * as url from 'node:url';

import {default as root} from './dsl/root.ts';
import {assertAspect} from './types/Project.ts';

import type {Aspect} from './types/Project.ts';

export default function getAspectFromCallers(
  callers: Array<string>,
): Aspect | null {
  for (const caller of callers) {
    if (caller.startsWith('file://')) {
      const path = url.fileURLToPath(caller);
      const ancestors = relative(root, path).split(sep);
      const aspect = ancestors[0] === 'aspects' && ancestors[1];

      if (aspect) {
        assertAspect(aspect);
        return aspect;
      }
    }
  }
  return null;
}
