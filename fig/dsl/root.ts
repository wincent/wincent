import {dirname, join} from 'node:path';
import {fileURLToPath} from 'node:url';

import {existsSync} from '../fs.ts';

const __dirname = dirname(fileURLToPath(import.meta.url));

/**
 * Determine repo root directory by walking up directory tree until we see the
 * "package-lock.json". We used to do this dynamically instead of using a hardcoded relative
 * path because the root could be in a different position depending on whether you were
 * starting from the "fig/dsl/root.ts" (source) or from "lib/fig/dsl/root.js"
 * (compiled).
 *
 * TODO: Now that we are running the source files directly, revisit this 👆
 */
const root = (function find(path): string {
  const target = 'package-lock.json';

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
