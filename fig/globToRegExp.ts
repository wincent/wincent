import escapeRegExpPattern from './escapeRegExpPattern.js';

/**
 * Just supports simple globs ("*") for now.
 */
export default function globToRegExp(glob: string): RegExp {
    const pattern = escapeRegExpPattern(glob);

    return new RegExp(pattern.replace(/\\\*/g, '[^/]+'));
}
