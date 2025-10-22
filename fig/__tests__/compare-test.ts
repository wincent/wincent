/**
 * @file
 *
 * Some light tests for `compare()`: can't really test a lot of the
 * permissions/ownership related stuff without relying on `sudo`, which
 * we don't want to have to do in the test suite.
 */

import assert from 'node:assert';
import {join} from 'node:path';
import {describe, test} from 'node:test';

import compare from '../compare.ts';
import root from '../dsl/root.ts';

/**
 * Helper to get fixtures (in "fig/") irrespective of where we run from.
 */
function fixture(...components: Array<string>): string {
  return join(root, 'fig', '__tests__', '__fixtures__', ...components);
}

describe('compare()', () => {
  describe('with {state: file} (implied)', () => {
    test('indicates when the file exists', async () => {
      const path = fixture('sample');

      const diff = await compare({path});

      assert.deepStrictEqual(diff, {path});
    });

    test('indicates when contents match', async () => {
      const path = fixture('sample');

      const diff = await compare({path, contents: 'sample contents\n'});

      assert.deepStrictEqual(diff, {
        path,
      });
    });

    test('indicates when contents do not match', async () => {
      const path = fixture('sample');

      const diff = await compare({path, contents: 'something'});

      assert.deepStrictEqual(diff, {
        contents: 'something',
        path,
      });
    });
  });

  describe('with {state: file} (explicit)', () => {
    test('returns an "empty" object for files that match', async () => {
      const path = fixture('sample');

      const diff = await compare({path, state: 'file'});

      assert.deepStrictEqual(diff, {path});
    });

    test('returns {state: "file"} for non-existent files', async () => {
      const path = fixture('non-existent');

      const diff = await compare({path, state: 'file'});

      assert.deepStrictEqual(diff, {
        path,
        state: 'file',
      });
    });

    test('complains if parent directory does not exist', async () => {
      const path = fixture('does', 'not', 'exist');

      const diff = await compare({path, state: 'file'});

      assert.deepStrictEqual(diff.path, path);
      assert.match(
        diff.error!.message,
        /Cannot stat ".+" because parent ".+" does not exist/,
      );
    });
  });

  describe('with {state: "absent"}', () => {
    test('returns an "empty" object for missing files', async () => {
      const path = fixture('non-existent');

      const diff = await compare({path, state: 'absent'});

      assert.deepStrictEqual(diff, {
        path,
      });
    });
  });
});
