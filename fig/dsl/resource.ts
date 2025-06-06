import {join} from 'node:path';

import Context from '../Context.ts';
import {readdirSync, statSync} from '../fs.ts';
import globToRegExp from '../globToRegExp.ts';
import path from '../path.ts';

import type {Dirent} from 'node:fs';

import type {Path} from '../path.ts';

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
      .filter(
        (entry) =>
          entry.isDirectory() || entry.isFile() || entry.isSymbolicLink(),
      )
      .filter(({name}) => components[0].test(name))
      .flatMap((entry: Dirent) => {
        const next = path(current).join(entry.name);

        if (entry.isSymbolicLink()) {
          const stat = statSync(next);

          if (stat.isDirectory()) {
            return traverse(next, components.slice(1));
          } else if (stat.isFile()) {
            return next;
          } else {
            return [];
          }
        } else if (entry.isDirectory() && components.length > 1) {
          return traverse(next, components.slice(1));
        } else if (components.length === 1) {
          return next;
        } else {
          return [];
        }
      });
  }

  return traverse(
    join('aspects', Context.currentAspect, subdirectory),
    path(glob).components.map((component) => globToRegExp(component)),
  );
}
