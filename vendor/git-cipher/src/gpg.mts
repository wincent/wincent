/**
 * SPDX-FileCopyrightText: Copyright 2013-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: MIT
 */

import assert from 'node:assert';

import run from './run.mts';

import type {Result, RunOptions} from './run.mts';

/**
 * Convenience wrapper that runs `gpg`. The last element in `args` may be a
 * `RunOptions` object.
 */
export default function gpg(
  ...args: Array<string | RunOptions>
): Promise<Result> {
  const strings: Array<string> = [];
  let runOptions: RunOptions | undefined;
  for (let i = 0; i < args.length; i++) {
    const arg = args[i];
    if (typeof arg === 'string') {
      strings.push(arg);
    } else {
      assert(i === args.length - 1);
      runOptions = arg;
    }
  }
  return run('gpg', strings, runOptions);
}
