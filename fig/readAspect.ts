import {join, relative, resolve} from 'node:path';

import {log} from './console.js';
import {promises as fs} from './fs.js';
import {root} from './index.js';
import {Aspect, assertAspect} from './types/Aspect.js';

export default async function readAspect(directory: string): Promise<Aspect> {
  await log.debug(`Reading aspect configuration: ${directory}`);

  let aspect;

  try {
    // First try for "aspect.js" in build output (lib/aspects) directory.
    const mod = resolve(
      root,
      'lib',
      relative(root, join(directory, 'aspect.js'))
    );

    aspect = (await import(mod)).default;
  } catch {
    // Fallback to "aspect.json" in source (aspects/) directory.
    const json = await fs.readFile(join(directory, 'aspect.json'), 'utf8');

    aspect = JSON.parse(json);
  }

  try {
    assertAspect(aspect);
  } catch (error) {
    if (error instanceof Error) {
      throw new Error(`${error.message} in ${directory}`);
    } else {
      throw new Error(
        `unknown error ${Object.prototype.toString.call(error)} in ${directory}`
      );
    }
  }

  return aspect;
}
