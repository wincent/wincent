import * as assert from 'assert';

import ErrorWithMetadata from '../ErrorWithMetadata';

import {COLORS, LOG_LEVEL, getLogLevel, log, print} from '../console';

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

let context: Array<string> = [];

export function describe(description: string, callback: () => void) {
  context.push(description);
  callback();
  context.pop();
}

export function expect(value: unknown) {
  return {
    toBe(expected: unknown) {
      assert.strictEqual(
        value,
        expected,
        `Expected ${stringify(value)} to be ${stringify(expected)}`
      );
    },

    toEqual(expected: unknown) {
      assert.deepStrictEqual(
        value,
        expected,
        `Expected ${stringify(value)} to equal ${stringify(expected)}`
      );
    },

    toMatch(expected: unknown) {
      if ((expected instanceof RegExp)) {
        assert(
          expected.test(String(value)),
          `Expected ${stringify(value)} to match ${stringify(expected)}`
        );
      } else {
        throw new Error(`Expected RegExp but received ${typeof expected}`);
      }
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
              expected
            )}`
          );
        } else if (expected instanceof RegExp) {
          assert.ok(
            expected.test(message),
            `Expected message ${stringify(message)} to match ${stringify(
              expected
            )}`
          );
        } else {
          assert.ok(
            caught instanceof expected,
            `Expected error to be instance of ${expected}`
          );
        }
      }
    },
  };
}

const RAQUO = '\u00bb';

export function test(description: string, callback: () => void) {
  TESTS.push([
    [...context, description].join(` ${RAQUO} `),
    callback
  ]);
}

export async function run() {
  const start = Date.now();

  const logLevel = getLogLevel();

  let failureCount = 0;
  let successCount = 0;

  log();

  for (const [description, callback] of TESTS) {
    try {
      print(yellow.reverse` TEST `, description);
      await callback();
      successCount++;
      // BUG: doesn't clear if line is too wide for terminal
      await print.clear();
      if (logLevel >= LOG_LEVEL.DEBUG) {
        log(green.reverse` PASS `, description);
      }
    } catch (error) {
      failureCount++;
      await print.clear();
      log(red.reverse` FAIL `, description);
      log(`\n${error.message}\n`);
      log(error);
      log();
    }
  }

  const elapsed = ((Date.now() - start) / 1000).toFixed(2);

  const successSummary = successCount
    ? green.bold`${successCount} passed`
    : '0 passed';

  const failureSummary = failureCount
    ? red.bold`${failureCount} failed`
    : `0 failed`;

  const totalSummary = `${successCount + failureCount} total in ${elapsed}s`;

  log();
  log(`${successSummary}, ${failureSummary}, ${totalSummary}`);
  if (logLevel < LOG_LEVEL.DEBUG) {
    log('Rerun with --debug to see full results');
  }
  log();

  if (failureCount) {
    throw new ErrorWithMetadata('Test suite failed');
  }
}
