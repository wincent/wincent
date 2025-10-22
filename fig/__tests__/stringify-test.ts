import assert from 'node:assert';
import {test} from 'node:test';

import dedent from '../dedent.ts';
import stringify from '../stringify.ts';

test('stringify() null', () => {
  assert.strictEqual(stringify(null), 'null');
});

test('stringify() undefined', () => {
  assert.strictEqual(stringify(undefined), 'undefined');
});

test('stringify() true', () => {
  assert.strictEqual(stringify(true), 'true');
});

test('stringify() false', () => {
  assert.strictEqual(stringify(false), 'false');
});

test('stringify() a number', () => {
  assert.strictEqual(stringify(9000), '9000');
});

test('stringify() a string', () => {
  assert.strictEqual(stringify('thing'), '"thing"');
});

test('stringify() a String', () => {
  assert.strictEqual(stringify(new String('thing')), '"thing"');
});

test('stringify() a Symbol', () => {
  assert.strictEqual(stringify(Symbol.for('sample')), 'Symbol(sample)');
});

test('stringify() an Error', () => {
  assert.strictEqual(
    stringify(new Error('Utter failure')),
    '"Error: Utter failure"',
  );
});

test('stringify() a RegExp', () => {
  assert.strictEqual(stringify(/stuff \w+/i), '/stuff \\w+/i');
});

test('stringify() an array', () => {
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

test('stringify() an empty array', () => {
  assert.strictEqual(stringify([]), '[]');
});

test('stringify() nested arrays', () => {
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

test('stringify() an array with circular references', () => {
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

test('stringify() an object', () => {
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

test('stringify() an empty object', () => {
  assert.strictEqual(stringify({}), '{}');
});

test('stringify() a nested object', () => {
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

test('stringify() an object with circular references', () => {
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

test('stringify() a Date', () => {
  assert.strictEqual(stringify(new Date()), '[object Date]');
});

test('stringify() a Set', () => {
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

test('stringify() an empty Set', () => {
  assert.strictEqual(stringify(new Set()), 'Set {}');
});

test('stringify() a one-line Function', () => {
  assert.strictEqual(stringify(() => 1), '() => 1');
});

// @ts-ignore: suppress TS7006: Parameter 'a' implicitly has an 'any' type.
function fn(a, b) {
  if (a > 0) {
    return a + b;
  }
}

test('stringify() a multi-line Function', () => {
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
