/**
 * SPDX-FileCopyrightText: Copyright 2013-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: MIT
 */

import assert from 'node:assert';
import {chmod} from 'node:fs/promises';

import Config from '../Config.mts';
import commonOptions from '../commonOptions.mts';
import * as log from '../log.mts';
import markdown from '../markdown.mts';
import removeCachedPlaintext from '../removeCachedPlaintext.mts';
import resetManagedFiles from '../resetManagedFiles.mts';

export const description =
  'unlocks the current repository, decrypting its secrets';

export const documentation = await markdown('git-cipher-unlock');

export async function execute(invocation: Invocation): Promise<number> {
  const config = new Config();

  const publicDirectory = await config.publicDirectory();
  if (!publicDirectory) {
    log.error(
      'unable to locate public directory; have you run `git cipher init`?',
    );
    return 1;
  }

  const errors = await config.checkConfig();
  if (errors.length) {
    log.error(
      'config errors detected that may be fixed by running `git cipher init`',
    );
    if (log.getLogLevel() < log.DEBUG) {
      log.info('re-run with `--debug` for more information');
    }
    for (const error of errors) {
      log.debug(error);
    }
    return 1;
  }

  const secrets = await config.decryptPublicSecrets();
  if (!secrets) {
    log.error('unable to decrypt secrets');
    return 1;
  }

  await config.unlockConfig();

  await config.writePrivateSecrets(secrets);

  const topLevel = await config.topLevel();
  assert(topLevel);
  await chmod(topLevel, 0o700);

  await removeCachedPlaintext();

  return resetManagedFiles(config, invocation);
}

// help will use this to figure out what to print for usage info
export const optionsSchema = {
  ...commonOptions,
  '--force': {
    defaultValue: false,
    kind: 'switch',
    description: 'replace ciphertext even if worktree is dirty',
  },
} as const;
