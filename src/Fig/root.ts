import {dirname, join} from 'path';
import {existsSync} from 'fs';

/**
 * Determine repo root directory by walking up directory tree until we see the
 * "yarn.lock". We do this dynamically instead of using a hardcoded relative
 * path because the root is in a different position depending on whether you are
 * starting form the "src/Fig/root.ts" or from "lib/src/Fig/root.ts".
 */
const root = (function find(path): string {
  const target = 'yarn.lock';

  if (existsSync(join(path, target))) {
    return path;
  } else {
    const next = dirname(path);

    if (next === path) {
      throw new Error(`Searched up to ${path} without finding ${target}`);
    }

    return find(dirname(path));
  }
})(__dirname);

export default root;
