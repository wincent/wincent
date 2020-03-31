/**
 * @file
 *
 * Some light tests for `compare()`: can't really test a lot of the
 * permissions/ownership related stuff without relying on `sudo`, which
 * we don't want to have to do in the test suite.
 */

import {join} from 'path';

import {describe, expect, test} from '../../test/harness';
import compare from '../compare';
import root from '../root';

/**
 * Helper to get fixtures (in "src/") irrespective of where we run from.
 */
function fixture(...components: Array<string>): string {
  return join(root, 'src', 'Fig', '__tests__', '__fixtures__', ...components);
}

describe('compare()', () => {
  describe('with {state: file} (implied)', () => {
    test('returns an "empty" object for files that match', async () => {
      const path = fixture('sample');

      const diff = await compare({path});

      expect(diff).toEqual({path});
    });
  });

  describe('with {state: file} (explicit)', () => {
    test('returns an "empty" object for files that match', async () => {
      const path = fixture('sample');

      const diff = await compare({path, state: 'file'});

      expect(diff).toEqual({path});
    });

    test('returns {state: "file"} for non-existent files', async () => {
      const path = fixture('non-existent');

      const diff = await compare({path, state: 'file'});

      expect(diff).toEqual({
        path,
        state: 'file'
      });
    });

    test('complains if parent directory does not exist', async () => {
      const path = fixture('does', 'not', 'exist');

      const diff = await compare({path, state: 'file'});

      expect(diff.path).toEqual(path);
      expect(diff.error!.message).toMatch(
        /Cannot stat ".+" because parent ".+" does not exist/
      );
    });
  });

  describe('with {state: "absent"}', () => {
    test('returns an "empty" object for missing files', async () => {
      const path = fixture('non-existent');

      const diff = await compare({path, state: 'absent'});

      expect(diff).toEqual({
        path,
      });
    });
  });
});
