import * as fs from 'fs';
import {join} from 'path';

import Context from './Context.js';
import globToRegExp from './globToRegExp.js';

// TODO: think about exporting these separately

/**
 * Given `name` returns an aspect-local path corresponding to the currently
 * active aspect (eg. `aspects/${aspect}/files/${name}`).
 */
export function file(...path: Array<string>): string {
    return join('aspects', Context.currentAspect, 'files', ...path);
}

/**
 * Very simple glob-based file search (doesn't supported nested directories).
 */
export function files(glob: string): Array<string> {
    const aspect = Context.currentAspect;

    const regExp = globToRegExp(glob);

    return fs
        .readdirSync(join('aspects', aspect, 'files'), {withFileTypes: true})
        .filter((entry) => entry.isFile())
        .map(({name}) => name)
        .filter((name) => regExp.test(name))
        .map((name) => join('aspects', aspect, 'files', name));
}

export function template(...path: Array<string>): string {
    return join('aspects', Context.currentAspect, 'templates', ...path);
}
