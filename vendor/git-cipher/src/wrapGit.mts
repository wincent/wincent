/**
 * SPDX-FileCopyrightText: Copyright 2013-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: MIT
 */

import {spawnSync} from 'node:child_process';

/**
 * Minimally wrap the specified Git `command`, endowing it with a `--reveal`
 * option that can reveal actual ciphertext as stored in Git's object storage.
 */
export default async function wrapGit(
  command: string,
  invocation: Invocation,
): Promise<number> {
  const args: Array<string> = [];

  // Pre-scan to make the main loop easier to write.
  const revealIndex = invocation.argv.indexOf('--reveal');
  const commandIndex = invocation.argv.indexOf(command);
  const textconvIndex = invocation.argv.findIndex((arg) =>
    /^--(?:no-)?textconv$/.test(arg)
  );
  const verbatimIndex = invocation.argv.indexOf('--');

  const shouldReveal = revealIndex !== -1 &&
    (verbatimIndex === -1 ? true : revealIndex < verbatimIndex);
  const shouldTextconv = (shouldReveal && textconvIndex === -1) ||
    (verbatimIndex === -1 ? false : textconvIndex > verbatimIndex);

  for (let i = 0; i < invocation.argv.length; i++) {
    const arg = invocation.argv[i]!;
    if (arg === '--') {
      args.push(...invocation.argv.slice(i));
      break;
    } else if (i === commandIndex) {
      if (shouldReveal) {
        args.unshift('-c', 'diff.git-cipher.binary=false');
      }
      args.push(arg);
      if (shouldTextconv) {
        args.push('--no-textconv');
      }
    } else if (i !== revealIndex || !shouldReveal) {
      args.push(arg);
    }
  }
  const result = spawnSync('git', args, {stdio: 'inherit'});
  if (typeof result.status === 'number') {
    return result.status;
  } else {
    return 1;
  }
}

export function revealSchema() {
  return {
    '--reveal': {
      defaultValue: false,
      kind: 'switch',
      description:
        `show raw ciphertext as it is literally stored in Git's object storage`,
    },
  } as const;
}
