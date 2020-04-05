import {homedir} from 'os';
import {join} from 'path';

export default function expand(path: string) {
    if (path.startsWith('~/')) {
        return join(homedir(), path.slice(2));
    } else {
        return path;
    }
}
