import * as assert from 'node:assert';
import {test} from 'node:test';

import regExpFromString from '../regExpFromString.ts';

test('regExpFromString() returns a RegExp', () => {
  const regExp = regExpFromString('/\\bword\\b/');

  assert.strictEqual(regExp instanceof RegExp, true);
  assert.strictEqual(regExp.source, '\\bword\\b');
  assert.strictEqual(regExp.flags, '');
});

test('regExpFromString() preserves flags', () => {
  const regExp = regExpFromString('/^foo/mig');

  assert.strictEqual(regExp instanceof RegExp, true);
  assert.strictEqual(regExp.source, '^foo');
  assert.strictEqual(regExp.flags, 'gim');
});

test('regExpFromString() rejects an invalid pattern', () => {
  assert.throws(() => regExpFromString('thing'), (error) => {
    return error instanceof Error &&
      error.message.includes(
        'Invalid pattern "thing" does not match /^\\/(.+)\\/([gimsuy]*)$/',
      );
  });
});
