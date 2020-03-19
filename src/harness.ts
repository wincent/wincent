import * as assert from 'assert';

const TESTS: Array<[string, () => void]> = [];

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

export function run() {
  const errors = [];

  TESTS.forEach(([description, callback]) => {
    try {
      console.log(description);
      callback();
    } catch (error) {
      console.log(error);
      errors.push(error);
    }
  });

  if (errors.length) {
    // bail...
  }
}
