export default function escapeRegExpPattern(pattern: string): string {
  // https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_Expressions
  return pattern.replace(/[.*+\-?^${}()|[\]\\]/g, '\\$&');
}
