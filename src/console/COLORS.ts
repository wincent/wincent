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

function bold(input: any, ...interpolations: unknown[]) {
    if (Array.isArray(input)) {
        return style(interpolate(input as any, interpolations), BOLD);
    } else {
        return style(input, BOLD);
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

function green(input: any, ...interpolations: unknown[]) {
    if (Array.isArray(input)) {
        return style(interpolate(input as any, interpolations), GREEN);
    } else {
        return style(input, GREEN);
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

function purple(input: any, ...interpolations: unknown[]) {
    if (Array.isArray(input)) {
        return style(interpolate(input as any, interpolations), PURPLE);
    } else {
        return style(input, PURPLE);
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

function red(input: any, ...interpolations: unknown[]) {
    if (Array.isArray(input)) {
        return style(interpolate(input as any, interpolations), RED);
    } else {
        return style(input, RED);
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

function reverse(input: any, ...interpolations: unknown[]) {
    if (Array.isArray(input)) {
        return style(interpolate(input as any, interpolations), REVERSE);
    } else {
        return style(input, REVERSE);
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

function yellow(input: any, ...interpolations: unknown[]) {
    if (Array.isArray(input)) {
        return style(interpolate(input as any, interpolations), YELLOW);
    } else {
        return style(input, YELLOW);
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
    bold(this: unknown, strings: any, ...interpolations: unknown[]): string {
        const result = bold(strings, ...interpolations);

        if (typeof this === 'function') {
            return this.call(null, result);
        } else {
            return result;
        }
    },

    green(this: unknown, strings: any, ...interpolations: unknown[]): string {
        const result = green(strings, ...interpolations);

        if (typeof this === 'function') {
            return this.call(null, result);
        } else {
            return result;
        }
    },

    purple(this: unknown, strings: any, ...interpolations: unknown[]): string {
        const result = purple(strings, ...interpolations);

        if (typeof this === 'function') {
            return this.call(null, result);
        } else {
            return result;
        }
    },

    red(this: unknown, strings: any, ...interpolations: unknown[]): string {
        const result = red(strings, ...interpolations);

        if (typeof this === 'function') {
            return this.call(null, result);
        } else {
            return result;
        }
    },

    reverse(this: unknown, strings: any, ...interpolations: unknown[]): string {
        const result = reverse(strings, ...interpolations);

        if (typeof this === 'function') {
            return this.call(null, result);
        } else {
            return result;
        }
    },

    yellow(this: unknown, strings: any, ...interpolations: unknown[]): string {
        const result = yellow(strings, ...interpolations);

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
