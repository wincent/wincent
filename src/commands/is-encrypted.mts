/**
 * SPDX-FileCopyrightText: Copyright 2013-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: MIT
 */

import {readFile} from 'node:fs/promises';
import {stdout} from 'node:process';

import {isErrnoException} from '../assert.mts';
import {isEncrypted} from '../clean.mts';
import commonOptions from '../commonOptions.mts';
import * as log from '../log.mts';
import markdown from '../markdown.mts';

export const description = 'reports whether a file is encrypted';

export const documentation = await markdown('git-cipher-is-encrypted');

export async function execute(invocation: Invocation): Promise<number> {
  if (!invocation.args.length) {
    log.error('`git-cipher is-encrypted` expects at least one argument');
    return 2;
  }
  let status = 0;
  for (const filename of invocation.args) {
    try {
      const buffer = await readFile(filename);
      const encrypted = isEncrypted(buffer);
      if (invocation.options['--exit-code']) {
        status = status || (encrypted ? 0 : 1);
      } else {
        stdout.write(`${filename} ${encrypted ? 'is' : 'is not'} encrypted\n`);
      }
    } catch (error) {
      if (isErrnoException(error)) {
        if (error.code === 'EISDIR') {
          log.error(`${filename} is a directory`);
        } else if (error.code === 'ENOENT') {
          log.error(`${filename} does not exist`);
        } else {
          log.error(`${filename}: ${error}`);
        }
        status = 2;
      } else {
        throw error;
      }
    }
  }
  return status;
}

export const optionsSchema = {
  ...commonOptions,
  '--exit-code': {
    defaultValue: false,
    kind: 'switch',
    description: 'short desc',
  },
} as const;
