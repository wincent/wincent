import * as assert from 'assert';

/**
 * Quick and dirty JSON check. Doesn't cover all edge cases, but it covers
 * enough.
 */
export function assertJSONValue(value: unknown): asserts value is JSONValue {
  assert.ok(isJSONValue(value));
}

export function isJSONValue(value: unknown): value is JSONValue {
    const seen = new Set();

    function check(value: unknown): value is JSONValue {
        if (
          typeof value === 'boolean' ||
          typeof value === 'number' ||
          typeof value === 'string' ||
          value === null
        ) {
          return true;
        } else if (Array.isArray(value) && !seen.has(value)) {
          seen.add(value);

          return value.every(check);
        } else if (
          typeof value === 'object' &&
          Object.prototype.toString.call(value) === '[object Object]' &&
          !seen.has(value)
        ) {
          seen.add(value);

          return Object.values(value!).every(check);
        }

        return false;
    }

    return check(value);
}
