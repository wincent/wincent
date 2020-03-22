import {join} from 'path';

/**
 * Given `name` returns an aspect-local path corresponding to the currently
 * active aspect (eg. `aspects/${aspect}/files/${name}`).
 */
export function file(name: string): string {
  return join('aspects', '[something]', 'files', name);
}

export function template(name: string): string {
  // TODO: actually implement
  return name;
}
