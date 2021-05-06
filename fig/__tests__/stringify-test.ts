import {expect, test} from '../test/harness.js';
import dedent from '../dedent.js';
import stringify from '../stringify.js';

test('stringify() null', () => {
  expect(stringify(null)).toBe('null');
});

test('stringify() undefined', () => {
  expect(stringify(undefined)).toBe('undefined');
});

test('stringify() true', () => {
  expect(stringify(true)).toBe('true');
});

test('stringify() false', () => {
  expect(stringify(false)).toBe('false');
});

test('stringify() a number', () => {
  expect(stringify(9000)).toBe('9000');
});

test('stringify() a string', () => {
  expect(stringify('thing')).toBe('"thing"');
});

test('stringify() a String', () => {
  expect(stringify(new String('thing'))).toBe('"thing"');
});

test('stringify() a Symbol', () => {
  expect(stringify(Symbol.for('sample'))).toBe('Symbol(sample)');
});

test('stringify() an Error', () => {
  expect(stringify(new Error('Utter failure'))).toBe('"Error: Utter failure"');
});

test('stringify() a RegExp', () => {
  expect(stringify(/stuff \w+/i)).toBe('/stuff \\w+/i');
});

test('stringify() an array', () => {
  expect(stringify([1, true, 'thing'])).toBe(
    dedent`
            [
              1,
              true,
              "thing",
            ]
        `.trimEnd()
  );
});

test('stringify() an empty array', () => {
  expect(stringify([])).toBe('[]');
});

test('stringify() nested arrays', () => {
  expect(stringify([1, true, 'thing', ['nested', null]])).toBe(
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
        `.trimEnd()
  );
});

test('stringify() an array with circular references', () => {
  const array: Array<any> = [1, true, 'thing'];

  array.push(array);

  expect(stringify(array)).toBe(
    dedent`
            [
              1,
              true,
              "thing",
              «circular»,
            ]
        `.trimEnd()
  );
});

test('stringify() an object', () => {
  expect(stringify({a: 1, b: true})).toBe(
    dedent`
            {
              "a": 1,
              "b": true,
            }
        `.trimEnd()
  );
});

test('stringify() an empty object', () => {
  expect(stringify({})).toBe('{}');
});

test('stringify() a nested object', () => {
  expect(stringify({a: 1, b: true, c: {d: null}})).toBe(
    dedent`
            {
              "a": 1,
              "b": true,
              "c": {
                "d": null,
              },
            }
        `.trimEnd()
  );
});

test('stringify() an object with circular references', () => {
  const object: {[key: string]: any} = {a: 1, b: true};

  object.c = object;

  expect(stringify(object)).toBe(
    dedent`
            {
              "a": 1,
              "b": true,
              "c": «circular»,
            }
        `.trimEnd()
  );
});

test('stringify() a Date', () => {
  expect(stringify(new Date())).toBe('[object Date]');
});

test('stringify() a Set', () => {
  expect(stringify(new Set([1, true, 'thing']))).toBe(
    dedent`
            Set {
              1,
              true,
              "thing",
            }
        `.trimEnd()
  );
});

test('stringify() an empty Set', () => {
  expect(stringify(new Set())).toBe('Set {}');
});

test('stringify() a one-line Function', () => {
  expect(stringify(() => 1)).toBe('() => 1');
});

// @ts-ignore: suppress TS7006: Parameter 'a' implicitly has an 'any' type.
function fn(a, b) {
  if (a > 0) {
    return a + b;
  }
}

test('stringify() a multi-line Function', () => {
  // Obviously this test is pretty fragile; depends on TS continuing to
  // use a 4-space indent in its build output.
  expect(stringify({fn})).toBe(
    dedent`
            {
              "fn": function fn(a, b) {
                  if (a > 0) {
                      return a + b;
                  }
              },
            }
        `.trimEnd()
  );
});
