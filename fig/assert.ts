import {isJSONValue} from './types/JSONValue.js';

/**
 * For those (many) places where we can't use Node's own `assert`
 * (because it's not currently typed as an "assert" function in the TS
 * sense).
 */
export default function assert(
  condition: any,
  message?: string
): asserts condition {
  if (!condition) {
    throw new Error(`assert(): ${message || 'assertion failed'}`);
  }
}

assert.JSONArray = function (
  value: any,
  message?: string
): asserts value is Array<JSONValue> {
  assert(
    Array.isArray(value) && value.every(isJSONValue),
    message || 'Expected value to be a JSON array'
  );
};

/**
 * Convenience helper for working with JSON objects.
 */
assert.JSONObject = function (
  value: any,
  message?: string
): asserts value is {[key: string]: JSONValue} {
  assert(
    value &&
      !Array.isArray(value) &&
      typeof value === 'object' &&
      Object.values(value).every(isJSONValue),
    message || 'Expected value to be a JSON object'
  );
};

const MODE_REGEXP = /^0[0-7]{3}$/;

assert.mode = function(mode: string): asserts mode is Mode {
  if (!MODE_REGEXP.test(mode)) {
    throw new Error(`Invalid mode ${mode}`);
  }
}
