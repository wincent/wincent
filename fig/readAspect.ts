import {join, relative, resolve} from 'node:path';

import {log} from './console.ts';
import root from './dsl/root.ts';
import {promises as fs} from './fs.ts';
import {type Aspect, assertAspect} from './types/Aspect.ts';

export default async function readAspect(directory: string): Promise<Aspect> {
  await log.debug(`Reading aspect configuration: ${directory}`);

  let aspect;

  try {
    // First try for "aspect.ts".
    const mod = resolve(
      root,
      relative(root, join(directory, 'aspect.ts')),
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
        `unknown error ${
          Object.prototype.toString.call(error)
        } in ${directory}`,
      );
    }
  }

  return aspect;
}
