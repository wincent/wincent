import {UnsupportedValueError, attributes, path, run, variable} from 'fig';

/**
 * @file
 *
 * Project-local helpers.
 */

type Condition =
  | 'arch'
  | 'arm64'
  | 'darwin'
  | 'debian'
  | 'linux'
  | 'personal'
  | 'wincent'
  | 'work';

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
 */
export function is(
  ...conditions: Array<Array<Condition> | Condition>
): boolean {
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
  ...conditions: Array<Array<Condition> | Condition>
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
function checkCondition(condition: Condition): boolean {
  switch (condition) {
    case 'arch':
      return attributes.distribution === 'arch';
    case 'arm64':
      return attributes.arch === 'arm64';
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
    case 'work':
      return variable('profile') === 'work';
    default:
      throw new UnsupportedValueError(condition);
  }
}

export async function isDecrypted(pathish: string): Promise<boolean> {
  const result = await run('bin/git-cipher', [
    'is-encrypted',
    '--exit-code',
    path(pathish).expand,
  ]);

  // 0 = encrypted, 1 = decrypted, anything else = error.
  return result.status === 1;
}
