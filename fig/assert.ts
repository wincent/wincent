import * as assert from 'node:assert';

import {isJSONObject, isJSONValue} from './types/JSONValue.ts';

export function assertJSONArray(
  value: unknown,
  message?: string,
): asserts value is Array<JSONValue> {
  assert.ok(
    Array.isArray(value) && value.every(isJSONValue),
    message || 'Expected value to be a JSON array',
  );
}

/**
 * Convenience helper for working with JSON objects.
 */
export function assertJSONObject(
  value: unknown,
  message?: string,
): asserts value is JSONObject {
  assert.ok(
    isJSONObject(value),
    message || 'Expected value to be a JSON object',
  );
}

const MODE_REGEXP = /^[0-7]{4}$/;

export function assertMode(mode: string): asserts mode is Mode {
  if (!MODE_REGEXP.test(mode)) {
    throw new Error(`Invalid mode ${mode}`);
  }
}
