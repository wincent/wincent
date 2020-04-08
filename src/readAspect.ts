import {promises as fs} from 'fs';

import {log} from './console/index.js';
import {Aspect, assertAspect} from './types/Aspect.js';

export default async function readAspect(path: string): Promise<Aspect> {
    log.debug(`Reading aspect configuration: ${path}`);

    const json = await fs.readFile(path, 'utf8');

    const aspect = JSON.parse(json);

    try {
        assertAspect(aspect);
    } catch (error) {
        throw new Error(`${error.message} in ${path}`);
    }

    return aspect;
}
