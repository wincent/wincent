import {assertJSONObject} from './assert.ts';
import * as fs from './fs.ts';
import merge from './merge.ts';
import {isPath} from './path.ts';

/**
 * Convenience function for merging JSON **objects** read from a series of
 * paths.
 *
 * Accepts strings (paths) or objects of the following form (indicating that the
 * path is optional, and should only be included if it exists on disk):
 *
 *     { optional: 'some/path' }
 */
export default async function mergePaths(
  ...paths: Array<string | {optional: string}>
): Promise<Variables> {
  let result: Variables = {};
  for (const path of paths) {
    if (typeof path === 'string' || isPath(path)) {
      const contents = await readPath(path);
      result = merge(result, contents);
    } else {
      // Optional path; only read it if it actually exists.
      if (fs.existsSync(path.optional)) {
        const contents = await readPath(path.optional);
        result = merge(result, contents);
      }
    }
  }
  return result;
}

async function readPath(path: string): Promise<JSONObject> {
  const contents = await fs.promises.readFile(path, 'utf8');
  const parsed = JSON.parse(contents);
  assertJSONObject(parsed);
  return parsed;
}
