import * as assert from 'assert';
import * as fs from 'fs';
import {promisify} from 'util';

import {log} from '../console';

const readFile = promisify(fs.readFile);

type Platform = 'darwin' | 'linux';

export interface Project {
  platforms: {
    [name in Platform]: Array<string>;
  };
  profiles?: {
    [name: string]: string;
  };
}

const PLATFORMS = new Set<Platform>(['darwin', 'linux']);

const PROPERTIES = new Set<keyof Project>(['platforms', 'profiles']);

export function assertProject(json: any): asserts json is Project {
  assert(json && typeof json === 'object');

  const missingKeys = json.hasOwnProperty('platforms') ? [] : ['platforms'];

  if (missingKeys.length) {
    throw new Error(
      `assertProject: Missing required keys: ${missingKeys.join(', ')}`
    );
  }

  const platforms = json.platforms;

  if (!platforms || typeof platforms !== 'object') {
    throw new Error('assertProject: "platforms" value is not an object');
  }

  const invalidPlatforms = Object.keys(platforms).filter(
    (value: any) => !PLATFORMS.has(value)
  );

  if (invalidPlatforms.length) {
    throw new Error(
      `assertProject: Invalid platform(s) ${invalidPlatforms.join(', ')}`
    );
  }

  Object.entries(platforms).forEach(([name, aspects]) => {
    if (
      !Array.isArray(aspects) ||
      aspects.some((aspect) => typeof aspect !== 'string')
    ) {
      throw new Error(
        `assertProject: Value for platform ${name} must be an array of strings`
      );
    }
  });

  const excessKeys = Object.keys(json).filter(
    (key: any) => !PROPERTIES.has(key)
  );

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
