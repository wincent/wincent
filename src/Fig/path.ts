import {join} from 'path';

/**
 * Given `name` returns an aspect-local path corresponding to the currently
 * active aspect (eg. `aspects/${aspect}/files/${name}`).
 */
export function file(...path: Array<string>): string {
  return join('aspects', '[something]', 'files', ...path);
}

export function template(...path: Array<string>): string {
  // TODO: actually implement
  return path[0];
}
