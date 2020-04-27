import {join} from 'path';

import Context from '../Context.js';
import {readdirSync} from '../fs.js';
import globToRegExp from '../globToRegExp.js';
import path from '../path.js';

import type {Path} from '../path.js';

// TODO: think about exporting these separately (from separate files)

/**
 * Given `components` returns an aspect-local path corresponding to the
 * currently active aspect; eg:
 *
 *      aspects/${aspect}/files/${name[0]}/${name[1]}...
 */
export function file(...components: Array<string>): Path {
    return resource('files', ...components);
}

/**
 * Very simple glob-based file search (only supports simple patterns like
 * "*.foo" and "thing/*.bar").
 */
export function files(glob: string): Array<Path> {
    const aspect = Context.currentAspect;

    const base = path(glob).dirname.toString();
    const regExp = globToRegExp(path(glob).basename);

    return readdirSync(join('aspects', aspect, 'files', base), {
        withFileTypes: true,
    })
        .filter((entry) => entry.isDirectory() || entry.isFile())
        .map(({name}) => name)
        .filter((name) => regExp.test(name))
        .map((name) => path(join('aspects', aspect, 'files', base, name)));
}

export function support(...components: Array<string>): Path {
    return resource('support', ...components);
}

export function template(...components: Array<string>): Path {
    return resource('templates', ...components);
}

function resource(subdirectory: string, ...components: Array<string>): Path {
    return path('aspects', Context.currentAspect, subdirectory, ...components);
}
