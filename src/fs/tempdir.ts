import mkdir from './mkdir.js';
import tempname from '../tempname.js';

export default async function tempdir(prefix: string): Promise<string> {
    const path = tempname(prefix);

    const result = await mkdir(path);

    if (result instanceof Error) {
        throw result;
    }

    return path;
}
