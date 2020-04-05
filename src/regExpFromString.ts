import stringify from './stringify';

/**
 * Loose definition of "valid" RegExp.
 */
const VALID_REGEXP = /^\/(.+)\/([gimsuy]*)$/;

export default function regExpFromString(pattern: string): RegExp {
    const match = pattern.match(VALID_REGEXP);

    if (!match) {
        throw new Error(
            `Invalid pattern ${stringify(
                pattern
            )} does not match ${VALID_REGEXP}`
        );
    }

    return new RegExp(match[1], match[2] || '');
}
