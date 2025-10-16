/**
 * SPDX-FileCopyrightText: Copyright 2013-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: MIT
 */

import markdown from '../markdown.mts';
import wrapGit, {revealSchema} from '../wrapGit.mts';

export const description = 'cipher-aware wrapper around `git diff`';

export const documentation = await markdown('git-cipher-diff');

export async function execute(invocation: Invocation): Promise<number> {
  return wrapGit('diff', invocation);
}

export const optionsSchema = {
  ...revealSchema(),
} as const;
