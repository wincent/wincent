import {resolve} from 'path';

import expand from './expand.js';

// TODO: probably put "expand" on Path-likes as well
export default function absolute(path: string) {
    return resolve(expand(path.toString()));
}
