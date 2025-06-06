import * as assert from 'node:assert';
import * as process from 'node:process';
import {Writable} from 'node:stream';

import ErrorWithMetadata from '../ErrorWithMetadata.ts';
import {RAQUO} from '../Unicode.ts';
import {COLORS, LOG_LEVEL, debug, getLogLevel, log, print} from '../console.ts';
import stringify from '../stringify.ts';

const {green, red, yellow} = COLORS;

const TESTS: Array<[string, () => void | Promise<void>]> = [];

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

    toMatch(expected: unknown) {
      if (expected instanceof RegExp) {
        assert.ok(
          expected.test(String(value)),
          `Expected ${stringify(value)} to match ${stringify(expected)}`,
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
        const message = caught instanceof Error
          ? caught.toString()
          : Object.prototype.toString.call(caught);

        if (typeof expected === 'string') {
          assert.ok(
            message.includes(expected),
            `Expected message ${stringify(message)} to contain ${
              stringify(
                expected,
              )
            }`,
          );
        } else if (expected instanceof RegExp) {
          assert.ok(
            expected.test(message),
            `Expected message ${stringify(message)} to match ${
              stringify(
                expected,
              )
            }`,
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

export function test(description: string, callback: () => void) {
  TESTS.push([[...context, description].join(` ${RAQUO} `), callback]);
}

export async function run() {
  const start = Date.now();

  let failureCount = 0;
  let successCount = 0;

  await debug(async () => await log());

  for (const [description, callback] of TESTS) {
    const write = {
      stderr: process.stderr.write,
      stdout: process.stdout.write,
    };

    let captured = '';

    const stream = new Writable({
      write(
        chunk: any,
        _encoding: string,
        callback: (error?: Error | null) => void,
      ) {
        captured += chunk.toString();
        callback();
      },
    });

    try {
      // Need to stay within one line if `clear()` calls below are to work.
      const trimmedDescription = description.slice(
        0,
        process.stderr.columns - ' TEST '.length - 1,
      );

      debug(() => print(yellow.reverse` TEST `, trimmedDescription));

      process.stderr.write = stream.write.bind(stream) as any;
      process.stdout.write = stream.write.bind(stream) as any;

      await callback();

      process.stderr.write = write.stderr;
      process.stdout.write = write.stdout;

      successCount++;
      await debug(async () => {
        await print.clear();
        await log(green.reverse` PASS `, description);
      });
    } catch (error) {
      process.stderr.write = write.stderr;
      process.stdout.write = write.stdout;

      failureCount++;
      await print.clear();
      await log(red.reverse` FAIL `, description);
      if (error instanceof Error) {
        await log(`\n${error.message}\n`);
      } else {
        await log(`\n${Object.prototype.toString.call(error)}\n`);
      }
      await log(error);
      await log();
    } finally {
      if (captured) {
        await log(captured);
      }
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

  const logLevel = getLogLevel();

  if (logLevel >= LOG_LEVEL.DEBUG || failureCount) {
    await log();
    await log(`${successSummary}, ${failureSummary}, ${totalSummary}`);
    if (logLevel < LOG_LEVEL.DEBUG) {
      await log('Rerun with --debug to see full results');
    }
    await log();
  }

  if (failureCount) {
    throw new ErrorWithMetadata('Test suite failed');
  }
}
