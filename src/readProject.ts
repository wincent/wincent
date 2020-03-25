import * as fs from 'fs';
import {promisify} from 'util';

import {log} from './console';
import {Project, assertProject} from './types/project';

const readFile = promisify(fs.readFile);

export default async function readProject(path: string): Promise<Project> {
  log.info(`Reading project: ${path}`);

  const json = await readFile(path, 'utf8');

  const project = JSON.parse(json);

  assertProject(project);

  return project;
}
