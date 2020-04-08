import {LAQUO, RAQUO} from './Unicode.js';

const CIRCULAR = `${LAQUO}circular${RAQUO}`;

/**
 * Basically `JSON.stringify()` but does a better job of printing some value
 * types (eg. a `RegExp` is printed as "/pattern/" instead of "{}" etc).
 */
export default function stringify(value: unknown) {
    let indent = '';

    const seen = new Set<unknown>();

    function traverse(value: unknown) {
        if (
            value == null ||
            typeof value === 'boolean' ||
            typeof value === 'number' ||
            typeof value === 'symbol' ||
            value instanceof RegExp
        ) {
            return String(value);
        } else if (typeof value === 'string') {
            return JSON.stringify(value);
        } else if (value instanceof Error) {
            return JSON.stringify(value.toString());
        } else if (Array.isArray(value)) {
            if (seen.has(value)) {
                return CIRCULAR;
            } else {
                seen.add(value);
                if (value.length) {
                    indent += '  ';
                    let array = '[\n';
                    array += value
                        .map((v) => {
                            return `${indent}${traverse(v)},`;
                        })
                        .join('\n');
                    indent = indent.slice(0, -2);
                    array += `\n${indent}]`;
                    return array;
                } else {
                    return '[]';
                }
            }
        } else if (value instanceof Set) {
            if (seen.has(value)) {
                return CIRCULAR;
            } else {
                seen.add(value);
                if (value.size) {
                    indent += '  ';
                    let set = 'Set {\n';
                    set += [...value.values()]
                        .map((v) => {
                            return `${indent}${traverse(v)},`;
                        })
                        .join('\n');
                    indent = indent.slice(0, -2);
                    set += `\n${indent}}`;
                    return set;
                } else {
                    return 'Set {}';
                }
            }
        } else if (typeof value === 'object') {
            // TODO: special-case Map too, if we need it
            const toString = Object.prototype.toString.call(value);
            if (toString === '[object Object]') {
                if (seen.has(value)) {
                    return CIRCULAR;
                } else {
                    seen.add(value);
                    const entries = Object.entries(value!);
                    if (entries.length) {
                        indent += '  ';
                        let object = '{\n';
                        object += Object.entries(value!)
                            .map(([key, value]) => {
                                return `${indent}${stringify(key)}: ${traverse(
                                    value
                                )},`;
                            })
                            .join('\n');
                        indent = indent.slice(0, -2);
                        object += `\n${indent}}`;
                        return object;
                    } else {
                        return '{}';
                    }
                }
            } else {
                return toString;
            }
        } else if (typeof value === 'function') {
            return value
                .toString()
                .split('\n')
                .map((line, i) => {
                    return i ? `${indent}${line}` : line;
                })
                .join('\n');
        } else {
            return `${LAQUO}unknown${RAQUO}`;
        }
    }

    return traverse(value);
}
