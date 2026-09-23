import {UnsupportedValueError, attributes, path, stat, variable} from 'fig';

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
  | 'vm'
  | 'wincent'
  | 'work'
  | {not: Condition};

/**
 * Returns `true` if `conditions` apply, which makes it useful in `if`
 * statements and expression contexts.
 *
 * `is()` wraps `when()` (see below), so it inherits its "AND" semantics at the
 * top level, and "OR" semantics for nested arrays of conditions. Nevertheless,
 * for readability, it is probably best reserved for simple (non-compound) cases
 * only; eg:
 *
 *    if (is('darwin')) {
 *      // Do something on Darwin only...
 *    }
 *
 * Using it for compound conditionals:
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
 *      // with the message "unsatisfied condition: (darwin)".
 *    });
 *
 * `conditions` is an array, and its entries must be either strings or nested
 * arrays of strings. Top-level conditions must be true using "AND" semantics.
 * Nested conditions employ "OR" semantics.
 *
 * For example, given `conditions` is `[['arch', 'debian'], 'wincent']`, the
 * semantics are equivalent to "(arch OR debian) AND (wincent)", which is
 * incidentally also in the string that is returned if the conditions are not
 * met:
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

    const toString = (condition: Condition): string => {
      if (typeof condition === 'string') {
        return condition;
      } else {
        return `NOT ${condition.not}`;
      }
    };

    const description = conditions
      .map((condition) => {
        return `(${
          Array.isArray(condition)
            ? condition.map(toString).join(' OR ')
            : toString(condition)
        })`;
      })
      .join(' AND ');

    return `unsatisfied condition: ${description}`;
  };
}

/**
 * For use in conjunction with `when()`, inverting the sense of the specified
 * condition. For example:
 *
 *    task('do this thing', when(not('darwin')), async () => {
 *      // On Darwin, task will be skipped with the message
 *      // "unsatisfied condition: (NOT darwin)".
 *    });
 *
 * Note that you could use it with `is()` as well, but there's not much point as
 * you can more simply write:
 *
 *    if (!is('darwin')) {}
 *
 */
export function not(condition: Condition): Condition {
  if (typeof condition === 'string') {
    return {not: condition};
  } else {
    return condition.not;
  }
}

/**
 * Provides a uniform interface for checking conditionals identified by a label.
 *
 * @internal
 */
function checkCondition(condition: Condition): boolean {
  if (typeof condition === 'string') {
    switch (condition) {
      case 'arch':
        return attributes.distribution === 'arch';
      case 'arm64':
        return attributes.arch === 'arm64' || attributes.arch === 'aarch64';
      case 'darwin':
        return attributes.platform === 'darwin';
      case 'debian':
        return attributes.distribution === 'debian';
      case 'linux':
        return attributes.platform === 'linux';
      case 'personal':
        return variable('profile') === 'personal';
      case 'vm':
        return attributes.distribution === 'debian';
      case 'wincent':
        return variable('identity') === 'wincent';
      case 'work':
        return variable('profile') === 'work';
      default:
        throw new UnsupportedValueError(condition);
    }
  } else {
    return !checkCondition(condition.not);
  }
}

export async function isDecrypted(pathish: string): Promise<boolean> {
  // If the file exists on disk, it has been decrypted.
  const result = await stat(path(pathish).expand);
  return result !== null && !(result instanceof Error);
}
