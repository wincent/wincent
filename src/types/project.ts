/**
 * vim: set nomodifiable :
 *
 * @generated
 */

import * as assert from 'assert';

export interface Project {
  platforms: {
    darwin?: Array<string>;
    linux?: Array<string>;
  }
  profiles?: {
    [key: string]: string;
  }
}

export function assertProject(json: any): asserts json is Project {
  assert(json && typeof json === 'object');

  const missingKeys = ['platforms'].filter(
    key => {
      return !json.hasOwnProperty(key);
    }
  );

  assert(!missingKeys.length);

  const allowedKeys = new Set(['platforms', 'profiles']);

  const excessKeys = Object.keys(json).filter(
    (key: any) => {
       return !allowedKeys.has(key);
    }
  );

  assert(!excessKeys.length);

  if (json.hasOwnProperty('platforms')) {
    const platforms = json.platforms;

    assert(platforms && typeof platforms === 'object');

    const allowedKeys = new Set(['darwin', 'linux']);

    const excessKeys = Object.keys(platforms).filter(
      (key: any) => {
         return !allowedKeys.has(key);
      }
    );

    assert(!excessKeys.length);

    if (platforms.hasOwnProperty('darwin')) {
      const darwin = platforms.darwin;

      assert(Array.isArray(darwin));
      assert(darwin.every((item: any) => typeof item === 'string'));
    }

    if (platforms.hasOwnProperty('linux')) {
      const linux = platforms.linux;

      assert(Array.isArray(linux));
      assert(linux.every((item: any) => typeof item === 'string'));
    }
  }

  if (json.hasOwnProperty('profiles')) {
    const profiles = json.profiles;

    assert(profiles && typeof profiles === 'object');
    assert(Object.values(profiles).every((value) => typeof value === 'string'));
  }
}
