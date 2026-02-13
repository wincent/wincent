/**
 * Turns `ms` into a human readable string like "1m2s" or "33.2s".
 *
 * Doesn't deal with timescales beyond "minutes" because we don't expect to see
 * those. If we did, it would just return (something like) "125m20s".
 */
export default function msToHumanReadable(ms: number): string {
  let seconds = ms / 1000;
  const minutes = Math.floor(seconds / 60);
  if (minutes) {
    seconds = Math.floor(seconds - minutes * 60);
  }

  let result = minutes ? `${minutes}m` : '';
  result += seconds
    ? seconds.toFixed(2).toString().replace(/0+$/, '').replace(/\.$/, '') + 's'
    : '';

  return result || '0s';
}
