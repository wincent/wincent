#!/usr/bin/env node

/*
 * Format with: prettier --write karabiner.js
 */

const assert = require('assert');
const { bundleIdentifier, deepCopy, isObject } = require('./karabiner');

(function test_bundleIdentifier() {
  (function $() {
    assert(
      bundleIdentifier('com.apple.TextEdit') === '^com\\.apple\\.TextEdit$',
      $,
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
    assert(
      JSON.stringify(copy) ===
        '{"object":{"isInner":true},"array":[1,2,[3,4]]}',
      $,
    );
  })();

  // Objects are cloned.
  (function $() {
    assert(source !== copy, $);
  })();

  // Nested objects are cloned.
  (function $() {
    assert(source.object !== copy.object, $);
  })();

  // Arrays are cloned.
  (function $() {
    assert(source.array !== copy.array, $);
  })();

  // Nested arrays are cloned.
  (function $() {
    assert(source.array[2] !== copy.array[2], $);
  })();

  // Primitives are identical.
  (function $() {
    assert(source.array[0] === copy.array[0], $);
  })();
})();

(function test_isObject() {
  // Arrays are not objects.
  (function $() {
    assert(!isObject([1]), $);
  })();

  // Booleans are not objects.
  (function $() {
    assert(!isObject(true), $);
  })();

  // `null` is not an object.
  (function $() {
    assert(!isObject(null), $);
  })();

  // Numbers are not objects.
  (function $() {
    assert(!isObject(1), $);
  })();

  // Strings are not objects.
  (function $() {
    assert(!isObject('this'), $);
  })();

  // `undefined` is not an object.
  (function $() {
    assert(!isObject(undefined), $);
  })();

  // Objects are objects.
  (function $() {
    assert(isObject({}), $);
  })();
})();
