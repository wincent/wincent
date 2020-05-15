import {relative, sep} from 'path';
import * as url from 'url';

import Context from '../Context.js';
import getCaller from '../getCaller.js';
import {assertAspect} from '../types/Project.js';
import {default as root} from './root.js';

export default function handler(name: string, callback: () => Promise<void>) {
    const caller = getCaller();

    const path = url.fileURLToPath(caller);

    const ancestors = relative(root, path).split(sep);

    const aspect =
        ancestors[0] === 'lib' && ancestors[1] === 'aspects' && ancestors[2];

    if (!aspect) {
        throw new Error(`Unable to determine aspect for ${caller}`);
    }

    assertAspect(aspect);

    Context.handlers.register(aspect, callback, `${aspect} | ${name}`);
}
