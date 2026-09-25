import {isJSONObject} from './types/JSONValue.ts';

/**
 * Merge collections of Variables.
 *
 * - Objects are merged recursively.
 * - Arrays are replaced.
 * - Returns a copy of the merged variables; input values are not mutated.
 *
 * Example:
 *
 *    // Merge `c` into `b`, then merge that into `a`.
 *    merge(a, b, c);
 */
export default function merge(
  variables: Readonly<Variables>,
  ...rest: Array<Readonly<Variables>>
): Variables {
  if (!rest.length) {
    return variables;
  } else if (rest.length === 1) {
    return mergeObjects(variables, rest[0]);
  } else {
    const last = rest.pop()!;
    const penultimate = rest.pop()!;

    return merge(variables, ...rest.concat(merge(penultimate, last)));
  }
}

function mergeObjects(target: Variables, source: Variables): Variables {
  const output: Variables = {...target};

  Object.entries(source).forEach(([key, value]) => {
    if (
      isJSONObject(value) &&
      isJSONObject(target[key])
    ) {
      output[key] = mergeObjects(target[key], value);
    } else {
      output[key] = value;
    }
  });

  return output;
}
