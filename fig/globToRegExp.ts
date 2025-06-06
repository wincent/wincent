import escapeRegExpPattern from './escapeRegExpPattern.ts';

/**
 * Just supports simple globs ("*") for now.
 */
export default function globToRegExp(glob: string): RegExp {
  const pattern = escapeRegExpPattern(glob);

  return new RegExp(pattern.replace(/\\\*/g, '[^/]+'));
}
