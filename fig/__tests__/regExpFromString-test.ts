import {expect, test} from '../test/harness.js';
import regExpFromString from '../regExpFromString.js';

test('regExpFromString() returns a RegExp', () => {
    const regExp = regExpFromString('/\\bword\\b/');

    expect(regExp instanceof RegExp).toBe(true);
    expect(regExp.source).toBe('\\bword\\b');
    expect(regExp.flags).toBe('');
});

test('regExpFromString() preserves flags', () => {
    const regExp = regExpFromString('/^foo/mig');

    expect(regExp instanceof RegExp).toBe(true);
    expect(regExp.source).toBe('^foo');
    expect(regExp.flags).toBe('gim');
});

test('regExpFromString() rejects an invalid pattern', () => {
    expect(() => regExpFromString('thing')).toThrow(
        'Invalid pattern "thing" does not match /^\\/(.+)\\/([gimsuy]*)$/'
    );
});
