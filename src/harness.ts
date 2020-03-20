import * as assert from 'assert';

import {COLORS, log, print} from './console';

const {green, red, yellow} = COLORS;

const TESTS: Array<[string, () => void | Promise<void>]> = [];

export function expect(value: unknown) {
  return {
    toBe(expected: unknown) {
      assert.equal(value, expected, `Expected ${value} to be ${expected}`);
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
      await print.clear();
      log(red.reverse` FAIL `, description);
    }
  }

  log();
  log(
    green.bold`${successCount} passed` + ',',
    red.bold`${failureCount} failed` + ',',
    `${successCount + failureCount} total`,
  );

  if (failureCount) {
    process.exit(1);
  }
}
