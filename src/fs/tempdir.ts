import {promises as fs} from 'fs';

import {log} from '../console';
import tempname from '../tempname';

export default async function tempdir(prefix: string): Promise<string> {
    const path = tempname(prefix);

    await fs.mkdir(path);

    log.debug(`Created directory at ${path}`);

    return path;
}
