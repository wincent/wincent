import {promises as fs} from 'fs';

import {log} from '../console';
import tempname from '../tempname';

/**
 * Writes the `contents` to a temporary file and returns the path to that file.
 * We rely on the operating system to clean-up such files (eventually), but
 * leave them on the disk for debugging purposes.
 */
export default async function tempdir(prefix: string): Promise<string> {
    const path = tempname(prefix);

    await fs.mkdir(path);

    log.debug(`Created directory at ${path}`);

    return path;
}
