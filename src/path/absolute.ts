import {resolve} from 'path';

import expand from './expand.js';

export default function absolute(path: string) {
    return resolve(expand(path));
}
