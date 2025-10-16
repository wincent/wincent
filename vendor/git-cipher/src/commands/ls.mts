/**
 * SPDX-FileCopyrightText: Copyright 2013-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: MIT
 */

import {readFile} from 'node:fs/promises';
import {join, relative, resolve} from 'node:path';
import {cwd, stdout} from 'node:process';

import Config from '../Config.mts';
import {isErrnoException} from '../assert.mts';
import commonOptions from '../commonOptions.mts';
import git from '../git.mts';
import * as log from '../log.mts';
import markdown from '../markdown.mts';
import parse from '../parse.mts';

export const description = 'lists encrypted files';

export const documentation = await markdown('git-cipher-ls');

// TODO: this should print to stdout, just like `ls`
// in general, there may be a bit of non-error output in various subcommands
// that would be better off going to stdout (but not all of it;
// clean/smudge/textconv, for example, definitely need to keep stdout clean)
export async function execute(invocation: Invocation): Promise<number> {
  const filters = invocation.args.map((arg) => {
    return resolve(arg);
  });
  const config = new Config();

  const topLevel = await config.topLevel();
  const managedFiles = await config.managedFiles();
  const untrackedManagedFiles = await config.untrackedManagedFiles();
  if (!topLevel || !managedFiles || !untrackedManagedFiles) {
    log.error('unable to list files');
    return 1;
  }

  for (const file of [...managedFiles, ...untrackedManagedFiles].sort()) {
    const relativePath = relative(cwd(), join(topLevel, file));

    if (filters.length) {
      const absolutePath = resolve(relativePath);
      if (
        !filters.some((filter) => {
          return (
            absolutePath === filter || absolutePath.startsWith(`${filter}/`)
          );
        })
      ) {
        continue;
      }
    }

    if (invocation.options['--verbose']) {
      const index = await indexStatus(relativePath);
      const worktree = await worktreeStatus(relativePath);
      const problematic = index === 'decrypted';
      const prefix = problematic ? `${log.BOLD}${log.RED}` : '';
      const suffix = problematic ? log.RESET : '';
      stdout.write(
        `${prefix}${relativePath} (index=${index}, worktree=${worktree})${suffix}\n`,
      );
    } else {
      stdout.write(`${relativePath}\n`);
    }
  }

  return 0;
}

type EncryptionStatus =
  | 'decrypted'
  | 'empty'
  | 'encrypted'
  | 'error'
  | 'missing'
  | 'untracked';

const PARSE_RESULT_TO_ENCRYPTION_STATUS = {
  'already-decrypted': 'decrypted',
  success: 'encrypted',
  error: 'error',
} as const;

function status(contents: Buffer): EncryptionStatus {
  if (contents.length) {
    const parseResult = parse(contents);
    return PARSE_RESULT_TO_ENCRYPTION_STATUS[parseResult.kind];
  } else {
    return 'empty';
  }
}

async function indexStatus(relativePath: string): Promise<EncryptionStatus> {
  const result = await git('show', `:0:${relativePath}`);
  if (result.success) {
    return status(result.stdout);
  } else if (typeof result.status === 'number' && result.status) {
    const stderr = result.stderr.toString();
    // Best effort at fuzzy matching error text (English only).
    if (stderr.includes('not in the index')) {
      return 'untracked';
    } else if (stderr.includes('does not exist')) {
      return 'missing';
    }
  }
  return 'error';
}

async function worktreeStatus(relativePath: string): Promise<EncryptionStatus> {
  try {
    const contents = await readFile(relativePath);
    return status(contents);
  } catch (error) {
    if (isErrnoException(error) && error.code === 'ENOENT') {
      return 'missing';
    }
    return 'error';
  }
}

export const optionsSchema = {
  ...commonOptions,
  '--verbose': {
    ...commonOptions['--verbose'],
    description: 'display status information for each file',
  },
} as const;
