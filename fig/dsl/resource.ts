import {join} from 'path';

import Context from '../Context.js';
import {readdirSync} from '../fs.js';
import globToRegExp from '../globToRegExp.js';
import path from '../path.js';

import type {Dirent} from 'fs';

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

export function files(glob: string): Array<Path> {
    return resources('files', glob);
}

export function support(...components: Array<string>): Path {
    return resource('support', ...components);
}

export function template(...components: Array<string>): Path {
    return resource('templates', ...components);
}

export function templates(glob: string): Array<Path> {
    return resources('templates', glob);
}

function resource(subdirectory: string, ...components: Array<string>): Path {
    return path('aspects', Context.currentAspect, subdirectory, ...components);
}

/**
 * Very simple glob-based file search (only supports simple patterns like
 * "*.foo" and "thing/*.bar").
 */
function resources(subdirectory: string, glob: string): Array<Path> {
    function traverse(current: string, components: Array<RegExp>): Array<Path> {
        return readdirSync(current, {withFileTypes: true})
            .filter((entry) => entry.isDirectory() || entry.isFile())
            .filter(({name}) => components[0].test(name))
            .flatMap((entry: Dirent) => {
                const next = path(current).join(entry.name);

                if (entry.isDirectory() && components.length > 1) {
                    return traverse(next, components.slice(1));
                } else {
                    return next;
                }
            });
    }

    return traverse(
        join('aspects', Context.currentAspect, subdirectory),
        path(glob).components.map((component) => globToRegExp(component))
    );
}
