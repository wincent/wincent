import * as assert from 'node:assert';
import {describe, test} from 'node:test';

import msToHumanReadable from '../msToHumanReadable.ts';

describe('msToHumanReadable()', () => {
  test('returns "0s" for 0', () => {
    assert.strictEqual(msToHumanReadable(0), '0s');
  });

  test('formats sub-second values', () => {
    assert.strictEqual(msToHumanReadable(500), '0.5s');
  });

  test('formats whole seconds', () => {
    assert.strictEqual(msToHumanReadable(3000), '3s');
  });

  test('formats fractional seconds', () => {
    assert.strictEqual(msToHumanReadable(33200), '33.2s');
  });

  test('formats minutes and seconds', () => {
    assert.strictEqual(msToHumanReadable(62000), '1m2s');
  });

  test('formats minutes only when seconds are 0', () => {
    assert.strictEqual(msToHumanReadable(120000), '2m');
  });

  test('handles large values', () => {
    assert.strictEqual(msToHumanReadable(7520000), '125m20s');
  });
});
