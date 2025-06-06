import {join, relative, resolve} from 'node:path';

import {log} from './console.ts';
import {root} from './index.ts';
import {type Project, assertProject} from './types/Project.ts';

export default async function readConfig(directory: string): Promise<Project> {
  await log.debug(`Reading project configuration: ${directory}`);

  const mod = resolve(
    root,
    relative(root, join(directory, 'fig.config.ts')),
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
