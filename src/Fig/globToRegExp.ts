/**
 * Just supports simple globs ("*") for now.
 */
export default function globToRegExp(glob: string): RegExp {
  const pattern = escapeRegExpPattern(glob);

  return new RegExp(pattern.replace(/\\\*/g, '[^/]+'));
}

function escapeRegExpPattern(pattern: string): string {
  // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_Expressions
  return pattern.replace(/[.*+\-?^${}()|[\]\\]/g, '\\$&');
}
