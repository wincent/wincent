/**
 * Tests for our karabiner.json generator script.
 *
 * These are probably overkill, but then, so is the script, and in any case, I
 * like my code to have Zarro Boogs.
 *
 * NOTE: These tests don't run as part of `./install --test` (which only runs
 * Fig tests). To run, do `node aspects/karabiner/support/karabiner-test.js`.
 */

import {ok} from 'node:assert';

import {bundleIdentifier} from './karabiner.js';

(function test_bundleIdentifier() {
  (function $() {
    ok(
      bundleIdentifier('com.apple.TextEdit') === '^com\\.apple\\.TextEdit$',
      $,
    );
  })();
})();
