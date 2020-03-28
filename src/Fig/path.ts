import * as fs from 'fs';
import {join} from 'path';

import globToRegExp from './globToRegExp';

// TODO: think about exporting these separately

/**
 * Given `name` returns an aspect-local path corresponding to the currently
 * active aspect (eg. `aspects/${aspect}/files/${name}`).
 */
export function file(...path: Array<string>): string {
  // TODO: get actual aspect
  const aspect = 'terminfo';

  return join('aspects', aspect, 'files', ...path);
}

/**
 * Very simple glob-based file search (doesn't supported nested directories).
 */
export function files(glob: string): Array<string> {
  // TODO: get actual aspect
  const aspect = 'terminfo';

  const regExp = globToRegExp(glob);

  return fs
    .readdirSync(join('aspects', aspect, 'files'), {withFileTypes: true})
    .filter((entry) => entry.isFile())
    .map(({name}) => name)
    .filter((name) => regExp.test(name))
    .map((name) => join('aspects', aspect, 'files', name));
}

export function template(...path: Array<string>): string {
  // TODO: actually implement
  return path[0];
}
