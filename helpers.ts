import {attributes, variable} from 'fig';

/**
 * @file
 *
 * Project-local helpers.
 */

/**
 * Returns `true` if `conditions` apply.
 *
 * Note that although it is possible to specify multiple conditions with AND
 * and OR semantics (as described in `when()` below), the `is()` function is
 * probably best reserved for simple (non-compound) cases only; eg:
 *
 *    if (is('darwin')) {
 *      // Do something on Darwin only...
 *    }
 *
 * because using it for compound conditionals:
 *
 *    if (is(['codespaces', 'work'])) {
 *      // ...
 *    }
 *
 * is likely to be _less_ readable than spelling out the underlying expressions
 * with explicit `||` and `&&` operators; eg:
 *
 *    if (profile === 'codespaces' || profile === 'work') {
 *      // ...
 *    }
 *
 */
export function is(...conditions: Array<Array<string> | string>): boolean {
  return when(...conditions)() === true;
}

/**
 * Returns a function that will return `true` if `conditions` apply, or a string
 * explaining why they do not apply. Mainly intended as a convenience for
 * defining conditional tasks:
 *
 *    task('do this thing', when('darwin'), async () => {
 *      // Only on Darwin... When not on Darwin, task will be skipped
 *      //  with the message "unsatisfied condition: (darwin)".
 *    });
 *
 * `conditions` is an array, and its entries must be either strings or nested
 * arrays of strings. Top-level conditions must be true using AND semantics.
 * Nested conditions employ OR semantics.
 *
 * That is, if `conditions` is `[['arch', 'debian'], 'wincent']`, the semantics
 * are equivalent to "(arch OR debian) AND (wincent)", which is incidentally
 * also in the string that is returned if the conditions are not met:
 *
 *    unsatisfied condition: (arch OR debian) AND (wincent)
 */
export function when(
  ...conditions: Array<Array<string> | string>
): () => true | string {
  return () => {
    if (
      conditions.every((condition) =>
        Array.isArray(condition)
          ? condition.some(checkCondition)
          : checkCondition(condition)
      )
    ) {
      return true;
    }

    const description = conditions
      .map((condition) => {
        return `(${
          Array.isArray(condition) ? condition.join(' OR ') : condition
        })`;
      })
      .join(' AND ');

    return `unsatisfied condition: ${description}`;
  };
}

/**
 * Provides a uniform interface for checking conditionals identified by a label.
 *
 * @internal
 */
function checkCondition(label: string): boolean {
  switch (label) {
    case 'arch':
      return attributes.distribution === 'arch';
    case 'arm64':
      return attributes.arch === 'arm64';
    case 'codespaces':
      return variable('hostHandle') === 'codespaces';
    case 'darwin':
      return attributes.platform === 'darwin';
    case 'debian':
      return attributes.distribution === 'debian';
    case 'linux':
      return attributes.platform === 'linux';
    case 'personal':
      return variable('profile') === 'personal';
    case 'wincent':
      return variable('identity') === 'wincent';
    default:
      throw new Error(
        `checkCondition(): Unknown condition label ${JSON.stringify(label)}`
      );
  }
}
