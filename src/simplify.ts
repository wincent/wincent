import {homedir} from 'os';
import {join} from 'path';

export default function simplify(path: string) {
    const home = homedir();

    if (path.startsWith(home)) {
        return join('~', path.slice(home.length));
    } else {
        return path;
    }
}
