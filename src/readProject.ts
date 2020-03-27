import * as fs from 'fs';
import {promisify} from 'util';

import {log} from './console';
import {Project, assertProject} from './types/Project';

const readFile = promisify(fs.readFile);

export default async function readProject(path: string): Promise<Project> {
  log.info(`Reading project configuration: ${path}`);

  const json = await readFile(path, 'utf8');

  const project = JSON.parse(json);

  try {
    assertProject(project);
  } catch (error) {
    throw new Error(`${error.message} in ${path}`);
  }

  return project;
}
