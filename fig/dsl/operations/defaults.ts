import Context from '../../Context.js';
import ErrorWithMetadata from '../../ErrorWithMetadata.js';
import Scanner from '../../Scanner.js';
import assert from '../../assert.js';
import {log} from '../../console.js';
import run from '../../run.js';
import stringify from '../../stringify.js';

type Type =
  | 'array'
  | 'array-add'
  | 'bool'
  | 'date'
  | 'dict'
  | 'dict-add'
  | 'float'
  | 'int'
  | 'string'
  | 'unknown';

export default async function defaults({
  domain = 'NSGlobalDomain',
  host,
  key,
  notify,
  state = 'present',
  type = 'string', // TODO: actually support all types
  value,
}: {
  domain?: string;
  host?: string;
  key: string;
  notify?: Array<string> | string;
  state?: 'absent' | 'present';
  type?: Exclude<Type, 'array' | 'date' | 'dict' | 'unknown'>;
  value?:
    | boolean
    | number
    | string
    | Array<boolean | number | string>
    | {[key: string]: boolean | number | string};
}): Promise<OperationResult> {
  if (state === 'present') {
    if (value === undefined) {
      throw new Error('Must provide a value if `state` is "present"');
    }

    if (type === 'bool' && typeof value !== 'boolean') {
      throw new Error('Must provide a boolean value if `type` is "bool"');
    }

    if (type === 'float' && typeof value !== 'number') {
      throw new Error('Must provide a number value if `type` is "float"');
    }

    if (type === 'int' && typeof value !== 'number') {
      throw new Error('Must provide a number value if `type` is "int"');
    }

    if (
      type === 'string' &&
      typeof value !== 'string' &&
      Object.prototype.toString.call(value) !== '[object String]'
    ) {
      throw new Error('Must provide a string value if `type` is "string"');
    }

    if (type === 'array-add' && (!Array.isArray(value) || !value.length)) {
      throw new Error(
        'Must provide a non-empty array value if `type` is "array-add"'
      );
    }

    if (
      type === 'dict-add' &&
      (!value ||
        Object.prototype.toString.call(value) !== '[object Object]' ||
        !Object.keys(value).length)
    ) {
      throw new Error(
        'Must provide a non-empty object value if `type` is "dict-add"'
      );
    }
  }

  const args = [];

  if (host === 'currentHost') {
    args.push('-currentHost');
  } else if (host !== undefined) {
    args.push('-host', host);
  }

  const description = ['defaults', ...args, domain, key].join(' ');

  let currentType: Exclude<Type, 'array-add' | 'dict-add'> | undefined;
  let currentValue:
    | boolean
    | number
    | string
    | undefined
    | Array<boolean | number | string>
    | {[key: string]: boolean | number | string};

  let result = await run('defaults', [...args, 'read-type', domain, key]);

  if (result.status !== 0) {
    // It's not documented, but `defaults` appears to exit with status 255
    // if invoked improperly, but with status 1 for non-fatal problems, such
    // as missing values.
    if (!/does not exist/.test(result.stderr)) {
      throw new ErrorWithMetadata(`Unable to read type of ${description}`, {
        ...result,
        error: result.error?.toString() ?? null,
      });
    }
  } else {
    const match = result.stdout.match(/Type is (?<type>\w+)/);

    if (match) {
      switch (match.groups!.type.toLowerCase()) {
        case 'array':
          currentType = 'array';
          break;
        case 'boolean':
          currentType = 'bool';
          break;
        case 'date':
          currentType = 'date';
          break;
        case 'dictionary':
          currentType = 'dict';
          break;
        case 'float':
          currentType = 'float';
          break;
        case 'integer':
          currentType = 'int';
          break;
        case 'string':
          currentType = 'string';
          break;
        default:
          currentType = 'unknown';
      }
    }
  }

  if (currentType !== undefined) {
    result = await run('defaults', [...args, 'read', domain, key]);

    if (result.status !== 0) {
      // Unlikely to get here (able to read type but not value).
      throw new ErrorWithMetadata(`Unable to read ${description}`, {
        ...result,
        error: result.error?.toString() ?? null,
      });
    }

    if (currentType === 'array') {
      currentValue = parseArray(result.stdout);
    } else if (currentType === 'bool') {
      currentValue = !!parseInt(result.stdout, 10);
    } else if (currentType === 'dict') {
      currentValue = parseDictionary(result.stdout);
    } else if (currentType === 'float') {
      currentValue = parseFloat(result.stdout);
    } else if (currentType === 'int') {
      currentValue = parseInt(result.stdout, 10);
    } else if (currentType === 'string') {
      currentValue = result.stdout.replace(/\r?\n$/, '');
    }
  }

  log.debug(
    `${description} current type = ${
      currentType ?? 'unset'
    }, current value = ${stringify(currentValue)}`
  );

  if (state === 'absent') {
    if (currentType === undefined) {
      return Context.informOk(`absent ${description}`);
    } else if (Context.options.check) {
      return Context.informSkipped(`absent ${description}`);
    } else {
      result = await run('defaults', [...args, 'delete', domain, key]);

      if (result.status !== 0) {
        throw new ErrorWithMetadata(`Unable to delete ${description}`, {
          ...result,
          error: result.error?.toString() ?? null,
        });
      }

      return Context.informChanged(`removed ${description}`, notify);
    }
  } else {
    if (equal(currentValue, currentType, value!, type)) {
      return Context.informOk(`present ${description}`);
    } else if (Context.options.check) {
      return Context.informSkipped(`present ${description}`);
    } else {
      let typeAndValue: Array<string> = [];

      if (type === 'array-add') {
        assert(Array.isArray(value));

        typeAndValue = ['-array-add', ...value.map(valueToString)];
      } else if (type === 'bool') {
        typeAndValue = ['-bool', valueToString(value)];
      } else if (type === 'dict-add') {
        assert(
          value && Object.prototype.toString.call(value) === '[object Object]'
        );

        typeAndValue = [
          '-dict-add',
          ...Object.entries(value).flatMap(([k, v]: [string, unknown]) => [
            k,
            valueToString(v),
          ]),
        ];
      } else if (type === 'float') {
        typeAndValue = ['-float', valueToString(value)];
      } else if (type === 'int') {
        typeAndValue = ['-int', valueToString(value)];
      } else if (type === 'string') {
        typeAndValue = ['-string', valueToString(value)];
      }

      result = await run('defaults', [
        ...args,
        'write',
        domain,
        key,
        ...typeAndValue,
      ]);

      if (result.status !== 0) {
        throw new ErrorWithMetadata(`Unable to set ${description}`, {
          ...result,
          error: result.error?.toString() ?? null,
        });
      }

      return Context.informChanged(
        `set ${description} ${stringify(value)}`,
        notify
      );
    }
  }
}

/**
 * @private
 *
 * Exported solely for testing purposes.
 */
export function equal(
  currentValue:
    | boolean
    | number
    | string
    | Array<boolean | number | string>
    | {[key: string]: boolean | number | string}
    | undefined,
  currentType:
    | 'array'
    | 'bool'
    | 'date'
    | 'dict'
    | 'float'
    | 'int'
    | 'string'
    | 'unknown'
    | undefined,
  desiredValue:
    | boolean
    | number
    | string
    | Array<boolean | number | string>
    | {[key: string]: boolean | number | string},
  desiredType: 'array-add' | 'bool' | 'dict-add' | 'float' | 'int' | 'string'
): boolean {
  if (
    currentType === 'unknown' ||
    currentType === undefined ||
    currentValue === undefined
  ) {
    return false;
  }

  if (desiredType === 'array-add') {
    if (currentType === 'array') {
      assert(Array.isArray(currentValue));
      assert(Array.isArray(desiredValue));

      return desiredValue.every((item) => {
        return currentValue.some((other) => other === item);
      });
    }

    return false;
  }

  if (desiredType === 'dict-add') {
    if (currentType === 'dict') {
      assert(
        currentValue &&
          typeof currentValue === 'object' &&
          !Array.isArray(currentValue)
      );
      assert(typeof desiredValue === 'object');

      return Object.entries(desiredValue).every(([key, value]) => {
        return currentValue[key] === value;
      });
    }

    return false;
  }

  if (desiredType === currentType) {
    return currentValue === desiredValue;
  }

  return false;
}

/**
 * @private
 *
 * Exported solely for testing purposes.
 *
 * Attempts to convert a simple (non-nested) array value printed by the
 * `defaults` command-line tool in a JS array.
 *
 * Example `defaults` output:
 *
 *      (
 *          en,
 *          "en_US",
 *          pt,
 *      )
 *
 * Produces this JS array:
 *
 *      ['en', 'en_US', 'pt']
 *
 * Returns `undefined` if the `defaults` output cannot be parsed.
 */
export function parseArray(
  value: string
): Array<boolean | number | string> | undefined {
  const scanner = new Scanner(value);

  // TODO: maybe support other types inside the array (eg. date)
  const result: Array<boolean | number | string> = [];

  if (!scanner.scan(/\s*\(\s*/)) {
    return undefined;
  }

  while (true) {
    for (const scan of [scanBoolean, scanNumber, scanString]) {
      const item = scan(scanner);

      if (item !== undefined) {
        result.push(item);
        break;
      }
    }

    if (!scanner.scan(/\s*,\s*/)) {
      break;
    }
  }

  if (!scanner.scan(/\s*\)\s*$/)) {
    return undefined;
  }

  return result;
}

/**
 * @private
 *
 * Exported solely for testing purposes.
 *
 * Attempts to convert a simple (non-nested) dictionary value printed by
 * the `defaults` command-line tool into a JS object.
 *
 * Example `defaults` (literal, raw) output:
 *
 *      {
 *          MaxAmount = 50;
 *          "Space-containing key" = "this one has\\na newline";
 *          "This \\"one\\" has quotes" = 1;
 *          "With \\\\ a slash" = 100;
 *      }
 *
 * Produces this JS object:
 *
 *      {
 *          MaxAmount: 50,
 *          'Space-containing key': 'this one has\na newline',
 *          'This "one" has quotes": 1,
 *          'With \\ a slash': 100,
 *      }
 *
 * Returns `undefined` if the `defaults` output cannot be parsed.
 */
export function parseDictionary(
  value: string
): {[key: string]: boolean | number | string} | undefined {
  const scanner = new Scanner(value);

  const result: {[key: string]: boolean | number | string} = {};

  if (!scanner.scan(/\s*\{\s*/)) {
    return undefined;
  }

  while (true) {
    const key = scanString(scanner);

    if (key) {
      if (!scanner.scan(/\s*=\s*/)) {
        return undefined;
      }

      const found = [scanBoolean, scanNumber, scanString].some((scan) => {
        const value = scan(scanner);

        if (value !== undefined) {
          result[key] = value;
          return true;
        }

        return false;
      });

      if (!found) {
        return undefined;
      }

      if (!scanner.scan(/\s*;\s*/)) {
        return undefined;
      }
    } else {
      break;
    }
  }

  if (!scanner.scan(/\s*\}\s*$/)) {
    return undefined;
  }

  return result;
}

/**
 * @private
 *
 * Exported solely for testing purposes.
 */
export function scanBoolean(scanner: Scanner): boolean | undefined {
  const boolean = scanner.scan(/[01]\b/);

  if (boolean === '0') {
    return false;
  } else if (boolean === '1') {
    return true;
  } else {
    return undefined;
  }
}

/**
 * @private
 *
 * Exported solely for testing purposes.
 */
export function scanNumber(scanner: Scanner): number | undefined {
  const number = scanner.scan(/\d+\b/);

  if (number) {
    return parseInt(number, 10);
  } else {
    return undefined;
  }
}

/**
 * @private
 *
 * Exported solely for testing purposes.
 */
export function scanString(scanner: Scanner): string | undefined {
  const index = scanner.index;

  if (scanner.scan('"')) {
    // Quoted string.
    let result = '';

    while (true) {
      if (scanner.scan('"')) {
        return result;
      }

      if (scanner.scan('\\\\')) {
        // Backslash: next character is supposed to be special...
        if (scanner.scan('\\\\')) {
          result += '\\';

          continue;
        } else if (scanner.scan('"')) {
          result += '"';

          continue;
        } else if (scanner.scan('n')) {
          result += '\n';

          continue;
        } else if (scanner.scan('r')) {
          result += '\r';

          continue;
        } else if (scanner.scan('t')) {
          result += '\t';

          continue;
        }
      }

      const next = scanner.scan(/[^\r\n]/);

      if (next !== undefined) {
        result += next;
        continue;
      }

      // Panic.
      break;
    }
  } else {
    // Bare word.
    return scanner.scan(/\w+/);
  }

  scanner.reset(index);

  return undefined;
}

/**
 * @private
 *
 * Exported solely for testing purposes.
 *
 * Prepare a value for passing as a string parameter to the `defaults`
 * command-line tool.
 */
export function valueToString(value: unknown): string {
  if (typeof value === 'boolean') {
    return value ? 'TRUE' : 'FALSE';
  } else if (typeof value === 'number') {
    return value.toString();
  } else if (
    typeof value === 'string' ||
    Object.prototype.toString.call(value) === '[object String]'
  ) {
    return String(value);
  } else {
    throw new Error('Unsupported value type');
  }
}
