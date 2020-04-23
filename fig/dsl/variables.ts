import {relative, sep} from 'path';
import * as url from 'url';

import Context from '../Context.js';
import getCaller from '../getCaller.js';
import {assertAspect} from '../types/Project.js';
import {default as root} from './root.js';

/**
 * Register a callback to dynamically contribute variables when an aspect is
 * running (useful for values that cannot be determined statically ahead of time
 * and stored in JSON).
 */
export default function variables(callback: (v: Variables) => Variables) {
    const caller = getCaller();

    const path = url.fileURLToPath(caller);

    const ancestors = relative(root, path).split(sep);

    const aspect =
        ancestors[0] === 'lib' && ancestors[1] === 'aspects' && ancestors[2];

    if (!aspect) {
        throw new Error(`Unable to determine aspect for ${caller}`);
    }

    assertAspect(aspect);

    Context.variables.register(aspect, callback);
}

// TODO: dedupe this, which is almost identical to task.ts
