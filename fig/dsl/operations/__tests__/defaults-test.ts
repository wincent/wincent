import * as assert from 'node:assert';
import {describe, test} from 'node:test';

import Scanner from '../../../Scanner.ts';
import {
  equal,
  parseArray,
  parseDictionary,
  scanBoolean,
  scanNumber,
  scanString,
  valueToString,
} from '../defaults.ts';

describe('equal()', () => {
  test('returns false if no current type and value', () => {
    assert.strictEqual(equal(undefined, undefined, true, 'bool'), false);
    assert.strictEqual(equal('<something>', 'unknown', true, 'bool'), false);

    // Shouldn't happen in practice, but just to show...
    assert.strictEqual(equal(undefined, 'string', true, 'bool'), false);
  });

  test('handles "array-add"', () => {
    // Not currently an array.
    assert.strictEqual(equal(true, 'bool', [100], 'array-add'), false);
    assert.strictEqual(equal({foo: true}, 'dict', [100], 'array-add'), false);
    assert.strictEqual(equal(10, 'float', [100], 'array-add'), false);
    assert.strictEqual(equal(20, 'int', [100], 'array-add'), false);
    assert.strictEqual(equal('foo', 'string', [100], 'array-add'), false);

    // Currently an array, but missing the desired value.
    assert.strictEqual(equal(['a', 'b'], 'array', ['c'], 'array-add'), false);

    // Currently an array, but missing a subset of desired values.
    assert.strictEqual(
      equal(['a', 'b'], 'array', ['b', 'c'], 'array-add'),
      false,
    );

    // Currently an array, and containing the desired value.
    assert.strictEqual(equal(['a', 'b'], 'array', ['b'], 'array-add'), true);

    // Currently an array, and containing multiple desired values.
    assert.strictEqual(
      equal(['a', 'b', 'c'], 'array', ['a', 'c'], 'array-add'),
      true,
    );
  });

  test('handles "dict-add"', () => {
    // Not currently a dictionary.
    assert.strictEqual(equal([10, 20], 'array', {a: 100}, 'dict-add'), false);
    assert.strictEqual(equal(true, 'bool', {a: 100}, 'dict-add'), false);
    assert.strictEqual(equal(10, 'float', {a: 100}, 'dict-add'), false);
    assert.strictEqual(equal(20, 'int', {a: 100}, 'dict-add'), false);
    assert.strictEqual(equal('foo', 'string', {a: 100}, 'dict-add'), false);

    // Currently a dictionary, but missing the desired key/value pair.
    assert.strictEqual(
      equal({a: 'foo'}, 'dict', {a: 'bar'}, 'dict-add'),
      false,
    );
    assert.strictEqual(
      equal({a: 'foo'}, 'dict', {b: 'bar'}, 'dict-add'),
      false,
    );

    // Currently a dictionary, but missing a subset of the desired
    // key/value pairs.
    assert.strictEqual(
      equal({a: 'foo'}, 'dict', {a: 'foo', b: 'bar'}, 'dict-add'),
      false,
    );

    // Currently a dictionary, and containing the desired key/value pair.
    assert.strictEqual(
      equal({a: 'foo', b: 'bar'}, 'dict', {b: 'bar'}, 'dict-add'),
      true,
    );

    // Currently a dictionary, and containing multiple desired
    // key/value pairs.
    assert.strictEqual(
      equal(
        {a: 'foo', b: 'bar', c: 'baz'},
        'dict',
        {b: 'bar', c: 'baz'},
        'dict-add',
      ),
      true,
    );
  });

  test('handles "bool"', () => {
    // Not currently a bool.
    assert.strictEqual(equal([10, 20], 'array', true, 'bool'), false);
    assert.strictEqual(equal({a: 'foo'}, 'dict', true, 'bool'), false);
    assert.strictEqual(equal(10, 'float', true, 'bool'), false);
    assert.strictEqual(equal(20, 'int', true, 'bool'), false);
    assert.strictEqual(equal('foo', 'string', true, 'bool'), false);

    // Currently a bool, but doesn't match.
    assert.strictEqual(equal(false, 'bool', true, 'bool'), false);

    // Currently a bool, and matches.
    assert.strictEqual(equal(false, 'bool', false, 'bool'), true);
  });

  test('handles "float"', () => {
    // Not currently a float.
    assert.strictEqual(equal([10, 20], 'array', 10, 'float'), false);
    assert.strictEqual(equal(true, 'bool', 10, 'float'), false);
    assert.strictEqual(equal({a: 'foo'}, 'dict', 10, 'float'), false);
    assert.strictEqual(equal(10, 'int', 10, 'float'), false);
    assert.strictEqual(equal('foo', 'string', 10, 'float'), false);

    // Currently a float, but doesn't match.
    assert.strictEqual(equal(20, 'float', 10, 'float'), false);

    // Currently a float, and matches.
    assert.strictEqual(equal(20, 'float', 20, 'float'), true);
  });

  test('handles "int"', () => {
    // Not currently an int.
    assert.strictEqual(equal([10, 20], 'array', 20, 'int'), false);
    assert.strictEqual(equal(true, 'bool', 20, 'int'), false);
    assert.strictEqual(equal({a: 'foo'}, 'dict', 20, 'int'), false);
    assert.strictEqual(equal(10, 'float', 20, 'int'), false);
    assert.strictEqual(equal('foo', 'string', 20, 'int'), false);

    // Currently an int, but doesn't match.
    assert.strictEqual(equal(10, 'int', 20, 'int'), false);

    // Currently an int, and matches.
    assert.strictEqual(equal(20, 'int', 20, 'int'), true);
  });

  test('handles "string"', () => {
    // Not currently a string.
    assert.strictEqual(equal([10, 20], 'array', 'foo', 'string'), false);
    assert.strictEqual(equal(true, 'bool', 'foo', 'string'), false);
    assert.strictEqual(equal({a: 'foo'}, 'dict', 'foo', 'string'), false);
    assert.strictEqual(equal(10, 'float', 'foo', 'string'), false);
    assert.strictEqual(equal(20, 'int', 'foo', 'string'), false);

    // Currently a string, but doesn't match.
    assert.strictEqual(equal('baz', 'string', 'foo', 'string'), false);

    // Currently a string, and matches.
    assert.strictEqual(equal('baz', 'string', 'baz', 'string'), true);
  });
});

describe('parseArray()', () => {
  test('it parses an empty array', () => {
    assert.deepStrictEqual(parseArray('()'), []);
    assert.deepStrictEqual(parseArray('(\n)'), []);
  });

  test('it parses an array with one item', () => {
    assert.deepStrictEqual(parseArray('(1)'), [true]);
    assert.deepStrictEqual(parseArray('(0)'), [false]);

    assert.deepStrictEqual(parseArray('(10)'), [10]);
    assert.deepStrictEqual(parseArray('(200)'), [200]);

    assert.deepStrictEqual(parseArray('(foo)'), ['foo']);
    assert.deepStrictEqual(parseArray('("foo")'), ['foo']);
  });

  test('it parses an array with multiple items', () => {
    assert.deepStrictEqual(parseArray('(1, 0, 1)'), [true, false, true]);
    assert.deepStrictEqual(parseArray('(1,0,1)'), [true, false, true]);
    assert.deepStrictEqual(parseArray('(\n1,\n  0,\n  1\n)'), [
      true,
      false,
      true,
    ]);

    assert.deepStrictEqual(parseArray('(10, 20, 10)'), [10, 20, 10]);
    assert.deepStrictEqual(parseArray('(10,20,10)'), [10, 20, 10]);
    assert.deepStrictEqual(parseArray('(\n10,\n  20,\n  10\n)'), [10, 20, 10]);

    assert.deepStrictEqual(parseArray('(foo, "bar", baz)'), [
      'foo',
      'bar',
      'baz',
    ]);
    assert.deepStrictEqual(parseArray('(foo,"bar",baz)'), [
      'foo',
      'bar',
      'baz',
    ]);
    assert.deepStrictEqual(parseArray('(\nfoo,\n  "bar",\n  baz\n)'), [
      'foo',
      'bar',
      'baz',
    ]);
  });

  test('it does not parse a nested array', () => {
    assert.strictEqual(parseArray('((1, 0), (0, 1))'), undefined);
  });
});

describe('parseDictionary()', () => {
  test('it parses an empty dictionary', () => {
    assert.deepStrictEqual(parseDictionary('{}'), {});
    assert.deepStrictEqual(parseDictionary('{\n}'), {});
  });

  test('it parses a dictionary with one key/value pair', () => {
    assert.deepStrictEqual(parseDictionary('{foo=1;}'), {foo: true});
    assert.deepStrictEqual(parseDictionary('{\n  foo = 1;\n}'), {foo: true});
    assert.deepStrictEqual(parseDictionary('{\n  "foo" = 1 ;\n}'), {foo: true});

    assert.deepStrictEqual(parseDictionary('{foo=100;}'), {foo: 100});
    assert.deepStrictEqual(parseDictionary('{\n  foo = 100;\n}'), {foo: 100});

    assert.deepStrictEqual(parseDictionary('{foo=bar;}'), {foo: 'bar'});
    assert.deepStrictEqual(parseDictionary('{\n  "foo" = "bar";\n}'), {
      foo: 'bar',
    });
  });

  test('it parses a dictionary with multiple key/value pairs', () => {
    assert.deepStrictEqual(parseDictionary('{foo=1;bar=baz;}'), {
      foo: true,
      bar: 'baz',
    });
    assert.deepStrictEqual(
      parseDictionary('{\n  foo = 1;\n  "bar" = "baz";\n}'),
      {
        foo: true,
        bar: 'baz',
      },
    );
  });

  test('it does not parse a nested dictionary', () => {
    assert.strictEqual(parseArray('{foo = {bar = 1;};}'), undefined);
  });
});

describe('scanBoolean()', () => {
  test('it scans a 0 as `false`', () => {
    assert.strictEqual(scanBoolean(new Scanner('0,')), false);
  });

  test('it scans a 1 as `true`', () => {
    assert.strictEqual(scanBoolean(new Scanner('1,')), true);
  });

  test('it does not scan 0 or 1 if part of a larger number', () => {
    assert.strictEqual(scanBoolean(new Scanner('100')), undefined);
  });

  test('it does not scan 0 or 1 if part of a word', () => {
    assert.strictEqual(scanBoolean(new Scanner('0x1234')), undefined);
  });

  test('it does not scan things that are not boolean representations', () => {
    assert.strictEqual(scanBoolean(new Scanner('foo')), undefined);
  });
});

describe('scanNumber()', () => {
  test('it scans an isolated number', () => {
    assert.strictEqual(scanNumber(new Scanner('1234')), 1234);
    assert.strictEqual(scanNumber(new Scanner('10-20')), 10);
  });

  test('it does not scan a number if it is part of a word', () => {
    assert.strictEqual(scanNumber(new Scanner('43things')), undefined);
  });

  test('it does not scan non-numbers', () => {
    assert.strictEqual(scanNumber(new Scanner('<>')), undefined);
  });
});

describe('scanString()', () => {
  test('it scans a bare word', () => {
    assert.strictEqual(scanString(new Scanner('foo.')), 'foo');
    assert.strictEqual(scanString(new Scanner('bar baz')), 'bar');
    assert.strictEqual(scanString(new Scanner('0xxx0')), '0xxx0');
  });

  test('it scans a quoted sentence', () => {
    assert.strictEqual(scanString(new Scanner('"foo bar"')), 'foo bar');
  });

  test('it scans a sentence that contains quotes', () => {
    assert.strictEqual(
      scanString(new Scanner('"foo \\\\"bar\\\\" baz"')),
      'foo "bar" baz',
    );
  });

  test('it scans a sentence that contains backslashes', () => {
    assert.strictEqual(
      scanString(new Scanner('"foo \\\\\\\\ bar"')),
      'foo \\ bar',
    );
  });

  test('it scans a sentence that contains newlines', () => {
    assert.strictEqual(scanString(new Scanner('"foo\\\\nbar"')), 'foo\nbar');
  });
});

describe('valueToString()', () => {
  test('turns boolean `true` into "TRUE"', () => {
    assert.strictEqual(valueToString(true), 'TRUE');
  });

  test('turns boolean `false` into "FALSE"', () => {
    assert.strictEqual(valueToString(false), 'FALSE');
  });

  test('turns numbers into string', () => {
    assert.strictEqual(valueToString(100), '100');
  });

  test('returns a primitive string as a primitive string', () => {
    assert.strictEqual(valueToString('thing'), 'thing');
  });

  test('turns a String instance into a primitive string', () => {
    assert.strictEqual(valueToString(new String('mine')), 'mine');
  });

  test('it rejects other types of input', () => {
    assert.throws(() => valueToString(undefined), /Unsupported value type/);
    assert.throws(() => valueToString(null), /Unsupported value type/);
    assert.throws(() => valueToString({}), /Unsupported value type/);
    assert.throws(() => valueToString([]), /Unsupported value type/);
    assert.throws(() => valueToString(new Date()), /Unsupported value type/);
  });
});
