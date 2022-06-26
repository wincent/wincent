import {log} from '../console.js';
import {promises as fs} from '../fs.js';
import tempname from './tempname.js';

/**
 * Writes the `contents` to a temporary file and returns the path to that file.
 * We rely on the operating system to clean-up such files (eventually), but
 * leave them on the disk for debugging purposes.
 */
export default async function tempfile(
  prefix: string,
  contents: string = '',
  encoding: BufferEncoding | null = 'utf8'
): Promise<string> {
  const path = tempname(prefix);

  await fs.writeFile(path, contents, {encoding});

  await log.debug(`Wrote ${contents.length} bytes to ${path}`);

  return path;
}
