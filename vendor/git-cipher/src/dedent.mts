/**
 * SPDX-FileCopyrightText: Copyright 2013-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: MIT
 */

export default function dedent(text: string): string {
  // Collapse totally blank lines to empty strings.
  const lines = text.split(/\r\n?|\n/).map((line: string) => {
    if (line.match(/^\s+$/)) {
      return '';
    } else {
      return line;
    }
  });

  // Find minimum indent (ignoring empty lines).
  const minimum = lines.reduce((acc: number, line: string) => {
    const indent = line.match(/^\s+/)?.[0];
    if (indent) {
      return Math.min(acc, indent.length);
    }
    return acc;
  }, Infinity);

  // Strip out minimum indent from every line.
  const dedented = isFinite(minimum)
    ? lines.map((line: string) =>
      line.replace(new RegExp(`^${' '.repeat(minimum)}`, 'g'), '')
    )
    : lines;

  // Trim first and last line if empty.
  if (dedented[0] === '') {
    dedented.shift();
  }

  if (dedented[dedented.length - 1] === '') {
    dedented.pop();
  }

  return dedented.join('\n') + '\n';
}
