/**
 * SPDX-FileCopyrightText: Copyright 2013-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: MIT
 */

import run from './run.mts';

import type {Result} from './run.mts';

export default function git(...args: Array<string>): Promise<Result> {
  return run('git', args);
}
