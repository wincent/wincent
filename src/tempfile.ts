import {randomBytes} from 'crypto';
import {promises as fs} from 'fs';
import {tmpdir} from 'os';
import {join} from 'path';

import {log} from './console';

const TMP_DIR = tmpdir();

/**
 * Writes the `contents` to a temporary file and returns the path to that file.
 * We rely on the operating system to clean-up such files (eventually), but
 * leave them on the disk for debugging purposes.
 */
export default async function tempfile(contents: string): Promise<string> {
    const name = randomBytes(16).toString('hex');

    const path = join(TMP_DIR, name);

    await fs.writeFile(path, contents, 'utf8');

    log.debug(`Wrote ${contents.length} bytes to ${path}`);

    return path;
}
