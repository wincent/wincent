import assert from 'node:assert';
import {describe, test} from 'node:test';

import Scanner from '../Scanner.ts';

describe('Scanner', () => {
  test('scan() finds matches', () => {
    const scanner = new Scanner('foo bar baz');

    assert.strictEqual(scanner.scan(/foo /), 'foo ');
    assert.strictEqual(scanner.scan(/nope/), undefined);

    // Can only find at current position.
    assert.strictEqual(scanner.scan(/baz/), undefined);
    assert.strictEqual(scanner.scan(/bar /), 'bar ');
    assert.strictEqual(scanner.scan(/baz/), 'baz');
  });

  test('scan() accepts string literals', () => {
    const scanner = new Scanner('foo (bar)');

    assert.strictEqual(scanner.scan('foo '), 'foo ');

    // Note how the parens would have special meaning in a RegExp, but they
    // get escaped here.
    assert.strictEqual(scanner.scan('(bar)'), '(bar)');
  });

  test('atEnd() informs when at end of string', () => {
    const scanner = new Scanner('foo bar baz');

    assert.strictEqual(scanner.atEnd(), false);

    scanner.scan(/.../);

    assert.strictEqual(scanner.atEnd(), false);

    scanner.scan(/.+/);

    assert.strictEqual(scanner.atEnd(), true);
  });

  test('peek() looks ahead', () => {
    const scanner = new Scanner('foo bar baz');

    scanner.scan('foo');

    assert.strictEqual(scanner.peek(), ' ');
    assert.strictEqual(scanner.peek(0), '');
    assert.strictEqual(scanner.peek(4), ' bar');
    assert.strictEqual(scanner.peek(4000), ' bar baz');
  });

  test('reading captures', () => {
    const scanner = new Scanner('foo bar baz');

    assert.strictEqual(scanner.captures, undefined);

    scanner.scan(/foo /);

    assert.deepStrictEqual(scanner.captures, []);

    assert.strictEqual(scanner.scan(/(\w+) (\w+)/), 'bar baz');

    assert.deepStrictEqual(scanner.captures, ['bar', 'baz']);
  });
});
