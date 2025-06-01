import {join, relative, resolve} from 'node:path';

import {log} from './console.js';
import {root} from './index.js';
import {type Project, assertProject} from './types/Project.js';

export default async function readConfig(directory: string): Promise<Project> {
  await log.debug(`Reading project configuration: ${directory}`);

  const mod = resolve(
    root,
    'lib',
    relative(root, join(directory, 'fig.config.js')),
  );

  const project = (await import(mod)).default;

  try {
    assertProject(project);
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

  return project;
}
