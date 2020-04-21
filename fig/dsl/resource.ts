import {join} from 'path';

import Context from '../Context.js';
import globToRegExp from '../Fig/globToRegExp.js';
import {readdirSync} from '../fs.js';
import path from '../path.js';

import type {Path} from '../path.js';

// TODO: think about exporting these separately (from separate files)

/**
 * Given `name` returns an aspect-local path corresponding to the currently
 * active aspect (eg. `aspects/${aspect}/files/${name}`).
 */
export function file(...components: Array<string>): Path {
    return path(join('aspects', Context.currentAspect, 'files', ...components));
}

/**
 * Very simple glob-based file search (doesn't supported nested directories).
 */
export function files(glob: string): Array<Path> {
    const aspect = Context.currentAspect;

    const regExp = globToRegExp(glob);

    return readdirSync(join('aspects', aspect, 'files'), {withFileTypes: true})
        .filter((entry) => entry.isDirectory() || entry.isFile())
        .map(({name}) => name)
        .filter((name) => regExp.test(name))
        .map((name) => path(join('aspects', aspect, 'files', name)));
}

export function template(...components: Array<string>): Path {
    return path(
        join('aspects', Context.currentAspect, 'templates', ...components)
    );
}
