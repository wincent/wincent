import * as assert from 'assert';

import {COLORS, log, print} from '../console';

const {green, red, yellow} = COLORS;

const TESTS: Array<[string, () => void | Promise<void>]> = [];

function stringify(value: unknown) {
  try {
    if (value instanceof RegExp) {
      return value.toString();
    } else {
      return JSON.stringify(value);
    }
  } catch {
    return Object.prototype.toString.call(value);
  }
}

export function expect(value: unknown) {
  return {
    toBe(expected: unknown) {
      assert.strictEqual(
        value,
        expected,
        `Expected ${stringify(value)} to be ${stringify(expected)}`,
      );
    },

    toEqual(expected: unknown) {
      assert.deepStrictEqual(
        value,
        expected,
        `Expected ${stringify(value)} to equal ${stringify(expected)}`,
      );
    },

    toThrow(expected: string | typeof Error | RegExp) {
      let caught;

      try {
        if (typeof value === 'function') {
          value();
        } else {
          throw new Error(`Expected function but received ${typeof value}`);
        }
      } catch (error) {
        caught = error;
      }

      if (!caught) {
        assert.fail('Expected error but none was thrown');
      } else {
        const message = caught.toString();

        if (typeof expected === 'string') {
          assert.ok(
            message.includes(expected),
            `Expected message ${stringify(message)} to contain ${stringify(
              expected,
            )}`,
          );
        } else if (expected instanceof RegExp) {
          assert.ok(
            expected.test(message),
            `Expected message ${stringify(message)} to match ${stringify(
              expected,
            )}`,
          );
        } else {
          assert.ok(
            caught instanceof expected,
            `Expected error to be instance of ${expected}`,
          );
        }
      }
    },
  };
}

export function test(description: string, callback: () => void): void {
  TESTS.push([description, callback]);
}

export async function run() {
  let failureCount = 0;
  let successCount = 0;

  for (const [description, callback] of TESTS) {
    try {
      print(yellow.reverse` TEST `, description);
      await callback();
      successCount++;
      await print.clear();
      log(green.reverse` PASS `, description);
    } catch (error) {
      failureCount++;
      await print.clear();
      log(red.reverse` FAIL `, description);
      log(`\n${error.message}\n`);
      log(error);
      log();
    }
  }

  const successSummary = successCount
    ? green.bold`${successCount} passed`
    : '0 passed';
  const failureSummary = failureCount
    ? red.bold`${failureCount} failed`
    : `0 failed`;

  log();
  log(
    `${successSummary}, ${failureSummary}, ${successCount +
      failureCount} total`,
  );

  if (failureCount) {
    process.exit(1);
  }
}
