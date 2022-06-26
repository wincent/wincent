import {join, relative, resolve} from 'path';

import {log} from './console.js';
import {promises as fs} from './fs.js';
import {root} from './index.js';
import {Project, assertProject} from './types/Project.js';

export default async function readProject(directory: string): Promise<Project> {
  log.debug(`Reading project configuration: ${directory}`);

  let project;

  try {
    // First try for "project.js" in build output (lib) directory.
    const mod = resolve(
      root,
      'lib',
      relative(root, join(directory, 'project.js'))
    );

    console.log(`trying ${mod}`);
    project = (await import(mod)).default;
  } catch {
    // Fallback to "project.json" in top-level directory.
    console.log(`trying ${join(directory, 'project.json')}`);
    const json = await fs.readFile(join(directory, 'project.json'), 'utf8');

    project = JSON.parse(json);
  }

  try {
    assertProject(project);
  } catch (error) {
    if (error instanceof Error) {
      throw new Error(`${error.message} in ${directory}`);
    } else {
      throw new Error(
        `unknown error ${Object.prototype.toString.call(error)} in ${directory}`
      );
    }
  }

  return project;
}
