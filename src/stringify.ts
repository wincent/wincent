import {LAQUO, RAQUO} from './Unicode';

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
        } else if (Array.isArray(value)) {
            if (seen.has(value)) {
                return CIRCULAR;
            } else {
                seen.add(value);
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
            }
        } else if (typeof value === 'object') {
            // TODO: special-case Set, Map
            const toString = Object.prototype.toString.call(value);
            if (toString === '[object Object]') {
                if (seen.has(value)) {
                    return CIRCULAR;
                } else {
                    seen.add(value);
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
