import * as fs from 'fs';
import {basename, dirname, join, normalize, resolve} from 'path';

import Context from './Context.js';
import globToRegExp from './globToRegExp.js';

// TODO: think about exporting these separately

const inspect = Symbol.for('nodejs.util.inspect.custom');

type Path = string & {
    basename: Path;
    dirname: Path;
    join: Path;
    resolve: Path;

    // Makes sure value as printed by `console.log()` looks like a string.
    [inspect]: () => string;
};

/**
 * Given `name` returns an aspect-local path corresponding to the currently
 * active aspect (eg. `aspects/${aspect}/files/${name}`).
 */
export function file(...path: Array<string>): Path {
    return toPath(join('aspects', Context.currentAspect, 'files', ...path));
}

/**
 * Very simple glob-based file search (doesn't supported nested directories).
 */
export function files(glob: string): Array<Path> {
    const aspect = Context.currentAspect;

    const regExp = globToRegExp(glob);

    return fs
        .readdirSync(join('aspects', aspect, 'files'), {withFileTypes: true})
        .filter((entry) => entry.isDirectory() || entry.isFile())
        .map(({name}) => name)
        .filter((name) => regExp.test(name))
        .map((name) => toPath(join('aspects', aspect, 'files', name)));
}

export function template(...path: Array<string>): Path {
    return toPath(join('aspects', Context.currentAspect, 'templates', ...path));
}

function toPath(string: string): Path {
    return Object.defineProperties(new String(string), {
        basename: {
            get() {
                return toPath(basename(string));
            },
        },

        dirname: {
            get() {
                return toPath(dirname(string));
            },
        },

        join: {
            value: (...components: Array<string>) => {
                return toPath(normalize(join(string, ...components)));
            },
        },

        resolve: {
            get() {
                return toPath(resolve(string));
            },
        },

        [inspect]: {
            value: () => string,
        },
    });
}
