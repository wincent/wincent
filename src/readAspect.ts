import * as fs from 'fs';
import {promisify} from 'util';

import {log} from './console';
import {Aspect, assertAspect} from './types/Aspect';

const readFile = promisify(fs.readFile);

export default async function readAspect(path: string): Promise<Aspect> {
  log.debug(`Reading aspect configuration: ${path}`);

  const json = await readFile(path, 'utf8');

  const aspect = JSON.parse(json);

  try {
    assertAspect(aspect);
  } catch (error) {
    throw new Error(`${error.message} in ${path}`);
  }

  return aspect;
}
