import {styleText} from 'node:util';

/**
 * Regular function.
 *
 * @overload
 */
function bold(input: string): string;

/**
 * Tagged template literal.
 *
 * @overload
 */
function bold(
  input: TemplateStringsArray,
  ...interpolations: unknown[]
): string;

function bold(
  input: string | TemplateStringsArray,
  ...interpolations: unknown[]
) {
  if (typeof input === 'string') {
    return styleText('bold', input);
  } else {
    return styleText('bold', interpolate(input, interpolations));
  }
}

/**
 * Regular function.
 *
 * @overload
 */
function green(input: string): string;

/**
 * Tagged template literal.
 *
 * @overload
 */
function green(
  input: TemplateStringsArray,
  ...interpolations: unknown[]
): string;

function green(
  input: string | TemplateStringsArray,
  ...interpolations: unknown[]
) {
  if (typeof input === 'string') {
    return styleText('green', input);
  } else {
    return styleText('green', interpolate(input, interpolations));
  }
}

/**
 * Regular function.
 *
 * @overload
 */
function magenta(input: string): string;

/**
 * Tagged template literal.
 *
 * @overload
 */
function magenta(
  input: TemplateStringsArray,
  ...interpolations: unknown[]
): string;

function magenta(
  input: string | TemplateStringsArray,
  ...interpolations: unknown[]
) {
  if (typeof input === 'string') {
    return styleText('magenta', input);
  } else {
    return styleText('magenta', interpolate(input, interpolations));
  }
}

/**
 * Regular function.
 *
 * @overload
 */
function red(input: string): string;

/**
 * Tagged template literal.
 *
 * @overload
 */
function red(input: TemplateStringsArray, ...interpolations: unknown[]): string;

function red(
  input: string | TemplateStringsArray,
  ...interpolations: unknown[]
) {
  if (typeof input === 'string') {
    return styleText('red', input);
  } else {
    return styleText('red', interpolate(input, interpolations));
  }
}

/**
 * Regular function.
 *
 * @overload
 */
function inverse(input: string): string;

/**
 * Tagged template literal.
 *
 * @overload
 */
function inverse(
  input: TemplateStringsArray,
  ...interpolations: unknown[]
): string;

function inverse(
  input: string | TemplateStringsArray,
  ...interpolations: unknown[]
) {
  if (typeof input === 'string') {
    return styleText('inverse', input);
  } else {
    return styleText('inverse', interpolate(input, interpolations));
  }
}

/**
 * Regular function.
 *
 * @overload
 */
function yellow(input: string): string;

/**
 * Tagged template literal.
 *
 * @overload
 */
function yellow(
  input: TemplateStringsArray,
  ...interpolations: unknown[]
): string;

function yellow(
  input: string | TemplateStringsArray,
  ...interpolations: unknown[]
) {
  if (typeof input === 'string') {
    return styleText('yellow', input);
  } else {
    return styleText('yellow', interpolate(input, interpolations));
  }
}

function interpolate(strings: TemplateStringsArray, interpolations: unknown[]) {
  return strings.reduce((acc, string, i) => {
    if (i < interpolations.length) {
      return acc + string + String(interpolations[i]);
    } else {
      return acc + string;
    }
  }, '');
}

const COLORS = {
  bold(
    this: unknown,
    strings: string | TemplateStringsArray,
    ...interpolations: unknown[]
  ): string {
    const result = typeof strings === 'string'
      ? bold(strings)
      : bold(strings, ...interpolations);

    if (typeof this === 'function') {
      return this.call(null, result);
    } else {
      return result;
    }
  },

  green(
    this: unknown,
    strings: string | TemplateStringsArray,
    ...interpolations: unknown[]
  ): string {
    const result = typeof strings === 'string'
      ? green(strings)
      : green(strings, ...interpolations);

    if (typeof this === 'function') {
      return this.call(null, result);
    } else {
      return result;
    }
  },

  magenta(
    this: unknown,
    strings: string | TemplateStringsArray,
    ...interpolations: unknown[]
  ): string {
    const result = typeof strings === 'string'
      ? magenta(strings)
      : magenta(strings, ...interpolations);

    if (typeof this === 'function') {
      return this.call(null, result);
    } else {
      return result;
    }
  },

  red(
    this: unknown,
    strings: string | TemplateStringsArray,
    ...interpolations: unknown[]
  ): string {
    const result = typeof strings === 'string'
      ? red(strings)
      : red(strings, ...interpolations);

    if (typeof this === 'function') {
      return this.call(null, result);
    } else {
      return result;
    }
  },

  inverse(
    this: unknown,
    strings: string | TemplateStringsArray,
    ...interpolations: unknown[]
  ): string {
    const result = typeof strings === 'string'
      ? inverse(strings)
      : inverse(strings, ...interpolations);

    if (typeof this === 'function') {
      return this.call(null, result);
    } else {
      return result;
    }
  },

  yellow(
    this: unknown,
    strings: string | TemplateStringsArray,
    ...interpolations: unknown[]
  ): string {
    const result = typeof strings === 'string'
      ? yellow(strings)
      : yellow(strings, ...interpolations);

    if (typeof this === 'function') {
      return this.call(null, result);
    } else {
      return result;
    }
  },
};

export default {
  bold: Object.assign(COLORS.bold, COLORS),
  green: Object.assign(COLORS.green, COLORS),
  magenta: Object.assign(COLORS.magenta, COLORS),
  red: Object.assign(COLORS.red, COLORS),
  inverse: Object.assign(COLORS.inverse, COLORS),
  yellow: Object.assign(COLORS.yellow, COLORS),
};
