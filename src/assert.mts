/**
 * SPDX-FileCopyrightText: Copyright 2013-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: MIT
 */

import assert from 'node:assert';

export function assertHasKey<
  O extends {[key: PropertyKey]: unknown},
  K extends PropertyKey,
>(object: O, key: K): asserts object is O & Record<K, unknown> {
  assert(hasKey(object, key));
}

export function assertIsObject(
  value: unknown,
): asserts value is {[key: string]: unknown} {
  assert(typeof value === 'object');
  assert(value);
  assert(Object.getPrototypeOf(value) === Object.prototype);
}

// May not need this after: https://github.com/microsoft/TypeScript/issues/44253
export function hasKey<
  O extends {[key: PropertyKey]: unknown},
  K extends PropertyKey,
>(object: O, key: K): object is O & Record<K, unknown> {
  return Object.hasOwn(object, key);
}

/**
 * Principally for working with the `fs/promises` API. The callback-based
 * APIs are already correctly typed, but the promise-based ones reject with
 * `unknown`.
 */
export function isErrnoException(
  error: unknown,
): error is NodeJS.ErrnoException {
  if (!(error instanceof Error)) {
    return false;
  }
  const errno = 'errno' in error ? error['errno'] : undefined;
  const code = 'code' in error ? error['code'] : undefined;
  const path = 'path' in error ? error['path'] : undefined;
  const syscall = 'syscall' in error ? error['syscall'] : undefined;
  return (
    (typeof errno === 'number' || typeof errno === 'undefined') &&
    (typeof code === 'string' || typeof code === 'undefined') &&
    (typeof path === 'string' || typeof path === 'undefined') &&
    (typeof syscall === 'string' || typeof syscall === 'undefined')
  );
}
