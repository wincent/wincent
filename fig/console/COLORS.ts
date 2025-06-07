/**
 * https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
 * https://stackoverflow.com/a/41407246/2103996
 */
const BOLD = '\x1b[1m';
const GREEN = '\x1b[32m';
const PURPLE = '\x1b[35m';
const RED = '\x1b[31m';
const RESET = '\x1b[0m';
const REVERSE = '\x1b[7m';
const YELLOW = '\x1b[33m';

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
    return style(input, BOLD);
  } else {
    return style(interpolate(input, interpolations), BOLD);
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
    return style(input, GREEN);
  } else {
    return style(interpolate(input, interpolations), GREEN);
  }
}

/**
 * Regular function.
 *
 * @overload
 */
function purple(input: string): string;

/**
 * Tagged template literal.
 *
 * @overload
 */
function purple(
  input: TemplateStringsArray,
  ...interpolations: unknown[]
): string;

function purple(
  input: string | TemplateStringsArray,
  ...interpolations: unknown[]
) {
  if (typeof input === 'string') {
    return style(input, PURPLE);
  } else {
    return style(interpolate(input, interpolations), PURPLE);
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
    return style(input, RED);
  } else {
    return style(interpolate(input, interpolations), RED);
  }
}

/**
 * Regular function.
 *
 * @overload
 */
function reverse(input: string): string;

/**
 * Tagged template literal.
 *
 * @overload
 */
function reverse(
  input: TemplateStringsArray,
  ...interpolations: unknown[]
): string;

function reverse(
  input: string | TemplateStringsArray,
  ...interpolations: unknown[]
) {
  if (typeof input === 'string') {
    return style(input, REVERSE);
  } else {
    return style(interpolate(input, interpolations), REVERSE);
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
    return style(input, YELLOW);
  } else {
    return style(interpolate(input, interpolations), YELLOW);
  }
}

function style(text: string, escape: string) {
  return `${escape}${text}${RESET}`;
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

  purple(
    this: unknown,
    strings: string | TemplateStringsArray,
    ...interpolations: unknown[]
  ): string {
    const result = typeof strings === 'string'
      ? purple(strings)
      : purple(strings, ...interpolations);

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

  reverse(
    this: unknown,
    strings: string | TemplateStringsArray,
    ...interpolations: unknown[]
  ): string {
    const result = typeof strings === 'string'
      ? reverse(strings)
      : reverse(strings, ...interpolations);

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
  purple: Object.assign(COLORS.purple, COLORS),
  red: Object.assign(COLORS.red, COLORS),
  reverse: Object.assign(COLORS.reverse, COLORS),
  yellow: Object.assign(COLORS.yellow, COLORS),
};
