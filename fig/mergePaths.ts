import {assertJSONObject} from './assert.ts';
import * as fs from './fs.ts';
import merge from './merge.ts';
import {isPath} from './path.ts';

/**
 * Convenience function for merging JSON **objects** read from a series of
 * paths.
 *
 * Accepts:
 *
 * - strings (paths)
 *
 * - objects of the following form (indicating that the path is optional, and
 *   should only be included if it exists on disk; eg. a maybe-not-decrypted-yet
 *   ciphertext):
 *
 *     { optional: 'some/path' }
 *
 * - null (useful for callsites that want to conditionally include/omit a path)
 */
export default async function mergePaths(
  ...paths: Array<string | {optional: string} | null>
): Promise<Variables> {
  let result: Variables = {};
  for (const path of paths) {
    if (typeof path === 'string' || isPath(path)) {
      const contents = await readPath(path);
      result = merge(result, contents);
    } else if (path) {
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
