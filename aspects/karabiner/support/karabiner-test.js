/**
 * Tests for our karabiner.json generator script.
 *
 * These are probably overkill, but then, so is the script, and in any case, I
 * like my code to have Zarro Boogs.
 */

import {ok} from 'assert';

import {bundleIdentifier, deepCopy, isObject, visit} from './karabiner.js';

(function test_bundleIdentifier() {
    (function $() {
        ok(
            bundleIdentifier('com.apple.TextEdit') ===
                '^com\\.apple\\.TextEdit$',
            $
        );
    })();
})();

(function test_deepCopy() {
    const source = {
        object: {
            isInner: true,
        },
        array: [1, 2, [3, 4]],
    };
    const copy = deepCopy(source);

    // Copies look the same.
    (function $() {
        ok(
            JSON.stringify(copy) ===
                '{"object":{"isInner":true},"array":[1,2,[3,4]]}',
            $
        );
    })();

    // Objects are cloned.
    (function $() {
        ok(source !== copy, $);
    })();

    // Nested objects are cloned.
    (function $() {
        ok(source.object !== copy.object, $);
    })();

    // Arrays are cloned.
    (function $() {
        ok(source.array !== copy.array, $);
    })();

    // Nested arrays are cloned.
    (function $() {
        ok(source.array[2] !== copy.array[2], $);
    })();

    // Primitives are identical.
    (function $() {
        ok(source.array[0] === copy.array[0], $);
    })();
})();

(function test_isObject() {
    // Arrays are not objects.
    (function $() {
        ok(!isObject([1]), $);
    })();

    // Booleans are not objects.
    (function $() {
        ok(!isObject(true), $);
    })();

    // `null` is not an object.
    (function $() {
        ok(!isObject(null), $);
    })();

    // Numbers are not objects.
    (function $() {
        ok(!isObject(1), $);
    })();

    // Strings are not objects.
    (function $() {
        ok(!isObject('this'), $);
    })();

    // `undefined` is not an object.
    (function $() {
        ok(!isObject(undefined), $);
    })();

    // Objects are objects.
    (function $() {
        ok(isObject({}), $);
    })();
})();

(function test_visit() {
    const subject = () => ({
        foo: 1,
        bar: [
            {
                a: [{}, {deep: {prop: 3}}],
            },
            {
                a: [],
                b: [{deep: {prop: 10}}],
            },
        ],
    });

    // Helpers for readability.
    const string = JSON.stringify;
    const squish = (s) => s.replace(/\s+/g, '');

    // Replacing the entire document.
    (function $() {
        const updated = visit(subject(), '$', (root) => 'replacement');
        ok(updated === 'replacement', $);
    })();

    // Setting a property on an object.
    (function $() {
        const updated = visit(subject(), '$.foo', (value) => value + 5);
        ok(
            string(updated) ===
                squish(`{
          "foo": 6,
          "bar": [
            {
              "a": [{}, { "deep": { "prop": 3 } }]
            },
            {
              "a": [],
              "b": [{ "deep": { "prop": 10 } }]
            }
          ]
        }`),
            $
        );
    })();

    // Modifying a list.
    (function $() {
        let counter = 10;
        const updated = visit(subject(), '$.bar[0:]', (_) => counter++);
        ok(
            string(updated) ===
                squish(`{
          "foo": 1,
          "bar": [10, 11]
        }`),
            $
        );
    })();

    // Re-cycling subtrees.
    (function $() {
        const original = subject();
        const updated = visit(
            original,
            '$.bar[0:].a[0:].deep',
            (value) => 'xxx'
        );

        ok(
            updated !== original &&
                updated.foo === original.foo &&
                updated.bar !== original.bar &&
                updated.bar[0] !== original.bar[0] &&
                updated.bar[0].a !== original.bar[0].a &&
                updated.bar[0].a[0] !== original.bar[0].a[0] &&
                updated.bar[1] === original.bar[1],
            $
        );
    })();
})();
