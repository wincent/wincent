import Scanner from '../../../Scanner.js';
import {describe, expect, test} from '../../../test/harness.js';
import {
  equal,
  parseArray,
  parseDictionary,
  scanBoolean,
  scanNumber,
  scanString,
  valueToString,
} from '../defaults.js';

describe('equal()', () => {
  test('returns false if no current type and value', () => {
    expect(equal(undefined, undefined, true, 'bool')).toBe(false);
    expect(equal('<something>', 'unknown', true, 'bool')).toBe(false);

    // Shouldn't happen in practice, but just to show...
    expect(equal(undefined, 'string', true, 'bool')).toBe(false);
  });

  test('handles "array-add"', () => {
    // Not currently an array.
    expect(equal(true, 'bool', [100], 'array-add')).toBe(false);
    expect(equal({foo: true}, 'dict', [100], 'array-add')).toBe(false);
    expect(equal(10, 'float', [100], 'array-add')).toBe(false);
    expect(equal(20, 'int', [100], 'array-add')).toBe(false);
    expect(equal('foo', 'string', [100], 'array-add')).toBe(false);

    // Currently an array, but missing the desired value.
    expect(equal(['a', 'b'], 'array', ['c'], 'array-add')).toBe(false);

    // Currently an array, but missing a subset of desired values.
    expect(equal(['a', 'b'], 'array', ['b', 'c'], 'array-add')).toBe(false);

    // Currently an array, and containing the desired value.
    expect(equal(['a', 'b'], 'array', ['b'], 'array-add')).toBe(true);

    // Currently an array, and containing multiple desired values.
    expect(equal(['a', 'b', 'c'], 'array', ['a', 'c'], 'array-add')).toBe(true);
  });

  test('handles "dict-add"', () => {
    // Not currently a dictionary.
    expect(equal([10, 20], 'array', {a: 100}, 'dict-add')).toBe(false);
    expect(equal(true, 'bool', {a: 100}, 'dict-add')).toBe(false);
    expect(equal(10, 'float', {a: 100}, 'dict-add')).toBe(false);
    expect(equal(20, 'int', {a: 100}, 'dict-add')).toBe(false);
    expect(equal('foo', 'string', {a: 100}, 'dict-add')).toBe(false);

    // Currently a dictionary, but missing the desired key/value pair.
    expect(equal({a: 'foo'}, 'dict', {a: 'bar'}, 'dict-add')).toBe(false);
    expect(equal({a: 'foo'}, 'dict', {b: 'bar'}, 'dict-add')).toBe(false);

    // Currently a dictionary, but missing a subset of the desired
    // key/value pairs.
    expect(equal({a: 'foo'}, 'dict', {a: 'foo', b: 'bar'}, 'dict-add')).toBe(
      false
    );

    // Currently a dictionary, and containing the desired key/value pair.
    expect(equal({a: 'foo', b: 'bar'}, 'dict', {b: 'bar'}, 'dict-add')).toBe(
      true
    );

    // Currently a dictionary, and containing multiple desired
    // key/value pairs.
    expect(
      equal(
        {a: 'foo', b: 'bar', c: 'baz'},
        'dict',
        {b: 'bar', c: 'baz'},
        'dict-add'
      )
    ).toBe(true);
  });

  test('handles "bool"', () => {
    // Not currently a bool.
    expect(equal([10, 20], 'array', true, 'bool')).toBe(false);
    expect(equal({a: 'foo'}, 'dict', true, 'bool')).toBe(false);
    expect(equal(10, 'float', true, 'bool')).toBe(false);
    expect(equal(20, 'int', true, 'bool')).toBe(false);
    expect(equal('foo', 'string', true, 'bool')).toBe(false);

    // Currently a bool, but doesn't match.
    expect(equal(false, 'bool', true, 'bool')).toBe(false);

    // Currently a bool, and matches.
    expect(equal(false, 'bool', false, 'bool')).toBe(true);
  });

  test('handles "float"', () => {
    // Not currently a float.
    expect(equal([10, 20], 'array', 10, 'float')).toBe(false);
    expect(equal(true, 'bool', 10, 'float')).toBe(false);
    expect(equal({a: 'foo'}, 'dict', 10, 'float')).toBe(false);
    expect(equal(10, 'int', 10, 'float')).toBe(false);
    expect(equal('foo', 'string', 10, 'float')).toBe(false);

    // Currently a float, but doesn't match.
    expect(equal(20, 'float', 10, 'float')).toBe(false);

    // Currently a float, and matches.
    expect(equal(20, 'float', 20, 'float')).toBe(true);
  });

  test('handles "int"', () => {
    // Not currently an int.
    expect(equal([10, 20], 'array', 20, 'int')).toBe(false);
    expect(equal(true, 'bool', 20, 'int')).toBe(false);
    expect(equal({a: 'foo'}, 'dict', 20, 'int')).toBe(false);
    expect(equal(10, 'float', 20, 'int')).toBe(false);
    expect(equal('foo', 'string', 20, 'int')).toBe(false);

    // Currently an int, but doesn't match.
    expect(equal(10, 'int', 20, 'int')).toBe(false);

    // Currently an int, and matches.
    expect(equal(20, 'int', 20, 'int')).toBe(true);
  });

  test('handles "string"', () => {
    // Not currently a string.
    expect(equal([10, 20], 'array', 'foo', 'string')).toBe(false);
    expect(equal(true, 'bool', 'foo', 'string')).toBe(false);
    expect(equal({a: 'foo'}, 'dict', 'foo', 'string')).toBe(false);
    expect(equal(10, 'float', 'foo', 'string')).toBe(false);
    expect(equal(20, 'int', 'foo', 'string')).toBe(false);

    // Currently a string, but doesn't match.
    expect(equal('baz', 'string', 'foo', 'string')).toBe(false);

    // Currently a string, and matches.
    expect(equal('baz', 'string', 'baz', 'string')).toBe(true);
  });
});

describe('parseArray()', () => {
  test('it parses an empty array', () => {
    expect(parseArray('()')).toEqual([]);
    expect(parseArray('(\n)')).toEqual([]);
  });

  test('it parses an array with one item', () => {
    expect(parseArray('(1)')).toEqual([true]);
    expect(parseArray('(0)')).toEqual([false]);

    expect(parseArray('(10)')).toEqual([10]);
    expect(parseArray('(200)')).toEqual([200]);

    expect(parseArray('(foo)')).toEqual(['foo']);
    expect(parseArray('("foo")')).toEqual(['foo']);
  });

  test('it parses an array with multiple items', () => {
    expect(parseArray('(1, 0, 1)')).toEqual([true, false, true]);
    expect(parseArray('(1,0,1)')).toEqual([true, false, true]);
    expect(parseArray('(\n1,\n  0,\n  1\n)')).toEqual([true, false, true]);

    expect(parseArray('(10, 20, 10)')).toEqual([10, 20, 10]);
    expect(parseArray('(10,20,10)')).toEqual([10, 20, 10]);
    expect(parseArray('(\n10,\n  20,\n  10\n)')).toEqual([10, 20, 10]);

    expect(parseArray('(foo, "bar", baz)')).toEqual(['foo', 'bar', 'baz']);
    expect(parseArray('(foo,"bar",baz)')).toEqual(['foo', 'bar', 'baz']);
    expect(parseArray('(\nfoo,\n  "bar",\n  baz\n)')).toEqual([
      'foo',
      'bar',
      'baz',
    ]);
  });

  test('it does not parse a nested array', () => {
    expect(parseArray('((1, 0), (0, 1))')).toBe(undefined);
  });
});

describe('parseDictionary()', () => {
  test('it parses an empty dictionary', () => {
    expect(parseDictionary('{}')).toEqual({});
    expect(parseDictionary('{\n}')).toEqual({});
  });

  test('it parses a dictionary with one key/value pair', () => {
    expect(parseDictionary('{foo=1;}')).toEqual({foo: true});
    expect(parseDictionary('{\n  foo = 1;\n}')).toEqual({foo: true});
    expect(parseDictionary('{\n  "foo" = 1 ;\n}')).toEqual({foo: true});

    expect(parseDictionary('{foo=100;}')).toEqual({foo: 100});
    expect(parseDictionary('{\n  foo = 100;\n}')).toEqual({foo: 100});

    expect(parseDictionary('{foo=bar;}')).toEqual({foo: 'bar'});
    expect(parseDictionary('{\n  "foo" = "bar";\n}')).toEqual({foo: 'bar'});
  });

  test('it parses a dictionary with multiple key/value pairs', () => {
    expect(parseDictionary('{foo=1;bar=baz;}')).toEqual({
      foo: true,
      bar: 'baz',
    });
    expect(parseDictionary('{\n  foo = 1;\n  "bar" = "baz";\n}')).toEqual({
      foo: true,
      bar: 'baz',
    });
  });

  test('it does not parse a nested dictionary', () => {
    expect(parseArray('{foo = {bar = 1;};}')).toBe(undefined);
  });
});

describe('scanBoolean()', () => {
  test('it scans a 0 as `false`', () => {
    expect(scanBoolean(new Scanner('0,'))).toBe(false);
  });

  test('it scans a 1 as `true`', () => {
    expect(scanBoolean(new Scanner('1,'))).toBe(true);
  });

  test('it does not scan 0 or 1 if part of a larger number', () => {
    expect(scanBoolean(new Scanner('100'))).toBe(undefined);
  });

  test('it does not scan 0 or 1 if part of a word', () => {
    expect(scanBoolean(new Scanner('0x1234'))).toBe(undefined);
  });

  test('it does not scan things that are not boolean representations', () => {
    expect(scanBoolean(new Scanner('foo'))).toBe(undefined);
  });
});

describe('scanNumber()', () => {
  test('it scans an isolated number', () => {
    expect(scanNumber(new Scanner('1234'))).toBe(1234);
    expect(scanNumber(new Scanner('10-20'))).toBe(10);
  });

  test('it does not scan a number if it is part of a word', () => {
    expect(scanNumber(new Scanner('43things'))).toBe(undefined);
  });

  test('it does not scan non-numbers', () => {
    expect(scanNumber(new Scanner('<>'))).toBe(undefined);
  });
});

describe('scanString()', () => {
  test('it scans a bare word', () => {
    expect(scanString(new Scanner('foo.'))).toBe('foo');
    expect(scanString(new Scanner('bar baz'))).toBe('bar');
    expect(scanString(new Scanner('0xxx0'))).toBe('0xxx0');
  });

  test('it scans a quoted sentence', () => {
    expect(scanString(new Scanner('"foo bar"'))).toBe('foo bar');
  });

  test('it scans a sentence that contains quotes', () => {
    expect(scanString(new Scanner('"foo \\\\"bar\\\\" baz"'))).toBe(
      'foo "bar" baz'
    );
  });

  test('it scans a sentence that contains backslashes', () => {
    expect(scanString(new Scanner('"foo \\\\\\\\ bar"'))).toBe('foo \\ bar');
  });

  test('it scans a sentence that contains newlines', () => {
    expect(scanString(new Scanner('"foo\\\\nbar"'))).toBe('foo\nbar');
  });
});

describe('valueToString()', () => {
  test('turns boolean `true` into "TRUE"', () => {
    expect(valueToString(true)).toBe('TRUE');
  });

  test('turns boolean `false` into "FALSE"', () => {
    expect(valueToString(false)).toBe('FALSE');
  });

  test('turns numbers into string', () => {
    expect(valueToString(100)).toBe('100');
  });

  test('returns a primitive string as a primitive string', () => {
    expect(valueToString('thing')).toBe('thing');
  });

  test('turns a String instance into a primitive string', () => {
    expect(valueToString(new String('mine'))).toBe('mine');
  });

  test('it rejects other types of input', () => {
    expect(() => valueToString(undefined)).toThrow('Unsupported value type');
    expect(() => valueToString(null)).toThrow('Unsupported value type');
    expect(() => valueToString({})).toThrow('Unsupported value type');
    expect(() => valueToString([])).toThrow('Unsupported value type');
    expect(() => valueToString(new Date())).toThrow('Unsupported value type');
  });
});
