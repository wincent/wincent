/**
 * Just supports simple globs ("*") for now.
 */
export default function globToRegExp(glob: string): RegExp {
  const pattern = RegExp.escape(glob.toString());
  return new RegExp(`^${pattern.replace(/\\\*/g, '[^/]+')}$`);
}
