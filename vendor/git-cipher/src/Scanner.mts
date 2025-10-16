/**
 * SPDX-FileCopyrightText: Copyright 2013-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: MIT
 */

import assert from 'node:assert';

/**
 * Simple scanner similar to the eponymous Ruby class.
 *
 * @see https://ruby-doc.org/stdlib-2.7.1/libdoc/strscan/rdoc/StringScanner.html
 */
export default class Scanner {
  captures: Array<string | undefined> | undefined;
  index: number;
  remaining: string;
  string: string;

  constructor(string: string) {
    this.index = 0;
    this.string = string;
    this.remaining = string;
  }

  atEnd(): boolean {
    return this.index === this.string.length;
  }

  /**
   * Checks to see if `pattern` matches at the current location and returns the
   * match, if any. Does not advance the index.
   */
  peek(pattern: string | RegExp): string | undefined {
    const peeked = this.scan(pattern);
    if (typeof peeked === 'string') {
      this.reset(this.index - peeked.length);
    }
    return peeked;
  }

  scan(pattern: string | RegExp): string | undefined {
    let regExp = typeof pattern === 'string'
      ? new RegExp(`^${escape(pattern)}`)
      : pattern;

    if (!regExp.source.startsWith('^')) {
      regExp = new RegExp(`^${regExp.source}`, regExp.flags);
    }

    if (regExp.flags.includes('g')) {
      regExp = new RegExp(`^${regExp.source}`, regExp.flags.replace('g', ''));
    }

    const match = this.remaining.match(regExp);

    if (match) {
      this.captures = match.slice(1);
      assert(typeof match[0] === 'string');
      this.reset(this.index + match[0].length);
      return match[0];
    } else {
      this.captures = undefined;
      return undefined;
    }
  }

  reset(index: number) {
    if (index < 0 || index > this.string.length) {
      throw new Error(`Index ${index} is out of bounds`);
    }

    this.index = index;
    this.remaining = this.string.slice(index);
  }
}

/**
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Regular_Expressions
 */
function escape(pattern: string): string {
  return pattern.replace(/[.*+\-?^${}()|[\]\\]/g, '\\$&');
}
