import {dirname, join} from 'node:path';
import {fileURLToPath} from 'node:url';

const __dirname = dirname(fileURLToPath(import.meta.url));

/**
 * The repo root directory.
 */
const root: string = join(__dirname, '../..');

export default root;
