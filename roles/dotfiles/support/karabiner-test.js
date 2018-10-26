#!/usr/bin/env node

/*
 * Format with: prettier --write karabiner.js
 */

const assert = require('assert');
const {
  bundleIdentifier,
  deepCopy,
  isObject,
} = require('./karabiner');

(function test_bundleIdentifier() {
  (function $() {
    assert(
      bundleIdentifier('com.apple.TextEdit') === '^com\\.apple\\.TextEdit$',
      $
    );
  })();
})();
