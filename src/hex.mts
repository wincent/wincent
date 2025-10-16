/**
 * SPDX-FileCopyrightText: Copyright 2013-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: MIT
 */

import assert from 'node:assert';
import type {Buffer} from 'node:buffer';

const WRAP_WIDTH = 72;

/**
 * "Pretty prints" one or more buffers as a wrapped hexadecimal string.
 *
 * Pass a `wrapWidth` of 0 to disable wrapping.
 */
export default function hex(
  buffer: Buffer | Uint8Array,
  wrapWidth: number = WRAP_WIDTH,
): string {
  assert(Number.isInteger(wrapWidth));
  assert(wrapWidth >= 0);
  const output = buffer.toString('hex');
  if (wrapWidth) {
    return output
      .replace(new RegExp(`.{1,${wrapWidth}}`, 'g'), '$&\n')
      .trimEnd();
  } else {
    return output;
  }
}
