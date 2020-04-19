import {homedir} from 'os';
import {basename, dirname, join, normalize, relative, resolve} from 'path';

const inspect = Symbol.for('nodejs.util.inspect.custom');

export type Path = string & {
    basename: Path;
    dirname: Path;
    expand: Path;
    join: (...components: Array<string>) => Path;
    resolve: Path;
    simplify: Path;

    // Makes sure value as printed by `console.log()` looks like a string.
    [inspect]: () => string;
};

export default function path(string: string): Path {
    // Unwrap (possible) Path back to primitive string.
    string = string.toString();

    return Object.defineProperties(new String(string), {
        basename: {
            get() {
                return path(basename(string));
            },
        },

        dirname: {
            get() {
                return path(dirname(string));
            },
        },

        expand: {
            get() {
                if (string.startsWith('~/')) {
                    return path(join(homedir(), string.slice(2)));
                } else {
                    return path(string);
                }
            },
        },

        join: {
            value: (...components: Array<string>) => {
                return path(
                    normalize(
                        join(string, ...components.map((c) => c.toString()))
                    )
                );
            },
        },

        resolve: {
            get() {
                if (string.startsWith('~/')) {
                    return path(normalize(join(homedir(), string.slice(2))));
                } else {
                    return path(resolve(string));
                }
            },
        },

        simplify: {
            get() {
                const home = homedir();

                if (string.startsWith(home)) {
                    return path(join('~', string.slice(home.length)));
                } else {
                    return path(relative('', string));
                }
            },
        },

        [inspect]: {
            value: () => string,
        },
    });
}

path.home = path('~');
