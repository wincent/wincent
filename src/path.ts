import {homedir} from 'os';
import {basename, dirname, join, normalize, relative, resolve} from 'path';

import Context from './Fig/Context.js';
import root from './Fig/root.js';

const inspect = Symbol.for('nodejs.util.inspect.custom');

// TODO: export path module wrappers as well, then I can just use it as a
// drop-in replacement
// TODO: decide whether this whole thing is an utterly terrible idea or not
// (can't do strict-equality comparisons with string-likes)
//
// Maybe a full-blown Path object (ie. not a string) would be better.

export type Path = string & {
    basename: Path;
    dirname: Path;
    expand: Path;
    join: (...components: Array<string>) => Path;
    resolve: Path;
    simplify: Path;
    strip: (extension?: string) => Path;

    // Makes sure value as printed by `console.log()` looks like a string.
    [inspect]: () => string;
};

interface path {
    (string: string): Path;

    aspect: Path;
    home: Path;
    root: Path;
}

function path(string: string): Path {
    // Unwrap (possible) Path string-like back to primitive string.
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

        /**
         * Strips off ".ext" identified by `extension`, if present.
         */
        strip: {
            value: (extension?: string) => {
                return path(join(dirname(string), basename(string, extension)));
            },
        },

        [inspect]: {
            value: () => string,
        },
    });
}

Object.defineProperty(path, 'aspect', {
    get() {
        return path(root).join('aspects', Context.currentAspect);
    },
});

export default Object.assign(path, {
    home: path('~'),

    root: path(root),
}) as path;
