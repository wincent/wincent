import * as assert from 'node:assert';
import {describe, test} from 'node:test';

import mergePaths from '../mergePaths.ts';
import path from '../path.ts';
import fixture from './fixture.ts';

const base = fixture('merge-paths', 'base.json');
const reset = fixture('merge-paths', 'reset.json');
const override = fixture('merge-paths', 'override.json');
const missing = fixture('merge-paths', 'non-existent.json');
// The result we expect from merging "override" into "base".
const expected = {
  name: 'override',
  list: ['override'],
  nested: {old: 1, new: 2},
};

describe('mergePaths()', () => {
  test('handles empty inputs, nulls, and missing optional files', async () => {
    assert.deepStrictEqual(await mergePaths(), {});
    assert.deepStrictEqual(await mergePaths(null, {optional: missing}), {});
  });

  test('gives later files precedence', async () => {
    assert.deepStrictEqual(await mergePaths(base, override), expected);
  });

  test('supports Path objects', async () => {
    assert.deepStrictEqual(
      await mergePaths(path(base), path(override)),
      expected,
    );
  });

  test('folds right with required paths', async () => {
    assert.deepStrictEqual(
      await mergePaths(base, null, reset, {optional: missing}, override),
      expected,
    );
  });

  test('folds right with optional paths', async () => {
    assert.deepStrictEqual(
      await mergePaths(
        {optional: path(base)},
        null,
        {optional: path(reset)},
        {optional: missing},
        {optional: path(override)},
      ),
      expected,
    );
  });

  test('rejects missing required files', async () => {
    await assert.rejects(mergePaths(missing), {code: 'ENOENT'});
  });

  test('does not ignore invalid JSON in optional files', async () => {
    await assert.rejects(
      mergePaths({optional: fixture('sample')}),
      SyntaxError,
    );
  });
});
