import * as fs from 'fs';
import {promisify} from 'util';

import {log} from '../console';

const readFile = promisify(fs.readFile);

export interface Project {
  profiles?: {
    [name: string]: string;
  };
}

export function assertProject(json: any): asserts json is Project {
  if (!json || typeof json !== 'object') {
    throw new Error('assertProject: Supplied value is not an object');
  }

  const excessKeys = Object.keys(json).filter((key) => key !== 'profiles');

  if (excessKeys.length) {
    throw new Error(
      `assertProject: Contains excess keys: ${excessKeys.join(', ')}`
    );
  }

  if (json.hasOwnProperty('profiles')) {
    const profiles = json.profiles;

    if (!profiles || typeof profiles !== 'object') {
      throw new Error('assertProject: "profiles" value is not an object');
    }

    if (!Object.values(profiles).every((value) => typeof value === 'string')) {
      throw new Error('assertProject: "profiles" object contains non-string');
    }
  }
}

export async function readProject(path: string): Promise<Project> {
  log.info(`Reading project: ${path}`);

  const json = await readFile(path, 'utf8');

  const project = JSON.parse(json);

  assertProject(project);

  return project;
}
