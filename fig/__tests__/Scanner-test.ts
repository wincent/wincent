import {describe, expect, test} from '../test/harness.js';
import Scanner from '../Scanner.js';

describe('Scanner', () => {
  test('scan() finds matches', () => {
    const scanner = new Scanner('foo bar baz');

    expect(scanner.scan(/foo /)).toBe('foo ');
    expect(scanner.scan(/nope/)).toBe(undefined);

    // Can only find at current position.
    expect(scanner.scan(/baz/)).toBe(undefined);
    expect(scanner.scan(/bar /)).toBe('bar ');
    expect(scanner.scan(/baz/)).toBe('baz');
  });

  test('scan() accepts string literals', () => {
    const scanner = new Scanner('foo (bar)');

    expect(scanner.scan('foo ')).toBe('foo ');

    // Note how the parens would have special meaning in a RegExp, but they
    // get escaped here.
    expect(scanner.scan('(bar)')).toBe('(bar)');
  });

  test('atEnd() informs when at end of string', () => {
    const scanner = new Scanner('foo bar baz');

    expect(scanner.atEnd()).toBe(false);

    scanner.scan(/.../);

    expect(scanner.atEnd()).toBe(false);

    scanner.scan(/.+/);

    expect(scanner.atEnd()).toBe(true);
  });

  test('peek() looks ahead', () => {
    const scanner = new Scanner('foo bar baz');

    scanner.scan('foo');

    expect(scanner.peek()).toBe(' ');
    expect(scanner.peek(0)).toBe('');
    expect(scanner.peek(4)).toBe(' bar');
    expect(scanner.peek(4000)).toBe(' bar baz');
  });

  test('reading captures', () => {
    const scanner = new Scanner('foo bar baz');

    expect(scanner.captures).toBe(undefined);

    scanner.scan(/foo /);

    expect(scanner.captures).toEqual([]);

    expect(scanner.scan(/(\w+) (\w+)/)).toBe('bar baz');

    expect(scanner.captures).toEqual(['bar', 'baz']);
  });
});
