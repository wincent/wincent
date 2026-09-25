import * as assert from 'node:assert';
import {describe, test} from 'node:test';

import dedent from '../dedent.ts';
import stringify from '../stringify.ts';

// @ts-ignore: suppress TS7006: Parameter 'a' implicitly has an 'any' type.
function fn(a, b) {
  if (a > 0) {
    return a + b;
  }
}

describe('stringify()', () => {
  test('null', () => {
    assert.strictEqual(stringify(null), 'null');
  });

  test('undefined', () => {
    assert.strictEqual(stringify(undefined), 'undefined');
  });

  test('true', () => {
    assert.strictEqual(stringify(true), 'true');
  });

  test('false', () => {
    assert.strictEqual(stringify(false), 'false');
  });

  test('a number', () => {
    assert.strictEqual(stringify(9000), '9000');
  });

  test('a string', () => {
    assert.strictEqual(stringify('thing'), '"thing"');
  });

  test('a String', () => {
    assert.strictEqual(stringify(new String('thing')), '"thing"');
  });

  test('a Symbol', () => {
    assert.strictEqual(stringify(Symbol.for('sample')), 'Symbol(sample)');
  });

  test('an Error', () => {
    assert.strictEqual(
      stringify(new Error('Utter failure')),
      '"Error: Utter failure"',
    );
  });

  test('an AggregateError', () => {
    const error = new AggregateError(
      [new Error('a'), new Error('b')],
      'all failed',
    );
    assert.strictEqual(
      stringify(error),
      dedent`
            "AggregateError: all failed" {
              "errors": [
                "Error: a",
                "Error: b",
              ],
            }
        `.trimEnd(),
    );
  });

  test('an Error with a cause', () => {
    const error = new Error('outer', {cause: new Error('inner')});
    assert.strictEqual(
      stringify(error),
      dedent`
            "Error: outer" {
              "cause": "Error: inner",
            }
        `.trimEnd(),
    );
  });

  test('an Error with a circular cause', () => {
    const error: Error & {cause?: unknown} = new Error('outer');
    error.cause = error;
    assert.strictEqual(
      stringify(error),
      dedent`
            "Error: outer" {
              "cause": «circular»,
            }
        `.trimEnd(),
    );
  });

  test('a RegExp', () => {
    assert.strictEqual(stringify(/stuff \w+/i), '/stuff \\w+/i');
  });

  test('an array', () => {
    assert.strictEqual(
      stringify([1, true, 'thing']),
      dedent`
            [
              1,
              true,
              "thing",
            ]
        `.trimEnd(),
    );
  });

  test('an empty array', () => {
    assert.strictEqual(stringify([]), '[]');
  });

  test('nested arrays', () => {
    assert.strictEqual(
      stringify([1, true, 'thing', ['nested', null]]),
      dedent`
            [
              1,
              true,
              "thing",
              [
                "nested",
                null,
              ],
            ]
        `.trimEnd(),
    );
  });

  test('an array with circular references', () => {
    const array: Array<unknown> = [1, true, 'thing'];

    array.push(array);

    assert.strictEqual(
      stringify(array),
      dedent`
            [
              1,
              true,
              "thing",
              «circular»,
            ]
        `.trimEnd(),
    );
  });

  test('an object', () => {
    assert.strictEqual(
      stringify({a: 1, b: true}),
      dedent`
            {
              "a": 1,
              "b": true,
            }
        `.trimEnd(),
    );
  });

  test('an empty object', () => {
    assert.strictEqual(stringify({}), '{}');
  });

  test('a nested object', () => {
    assert.strictEqual(
      stringify({a: 1, b: true, c: {d: null}}),
      dedent`
            {
              "a": 1,
              "b": true,
              "c": {
                "d": null,
              },
            }
        `.trimEnd(),
    );
  });

  test('an object with circular references', () => {
    const object: {[key: string]: any} = {a: 1, b: true};

    object.c = object;

    assert.strictEqual(
      stringify(object),
      dedent`
            {
              "a": 1,
              "b": true,
              "c": «circular»,
            }
        `.trimEnd(),
    );
  });

  test('a Date', () => {
    assert.strictEqual(stringify(new Date()), '[object Date]');
  });

  test('a Set', () => {
    assert.strictEqual(
      stringify(new Set([1, true, 'thing'])),
      dedent`
            Set {
              1,
              true,
              "thing",
            }
        `.trimEnd(),
    );
  });

  test('an empty Set', () => {
    assert.strictEqual(stringify(new Set()), 'Set {}');
  });

  test('a one-line Function', () => {
    assert.strictEqual(stringify(() => 1), '() => 1');
  });

  test('a multi-line Function', () => {
    assert.strictEqual(
      stringify({fn}),
      dedent`
            {
              "fn": function fn(a, b) {
                if (a > 0) {
                  return a + b;
                }
              },
            }
        `.trimEnd(),
    );
  });
});
