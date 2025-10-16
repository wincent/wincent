/**
 * SPDX-FileCopyrightText: Copyright 2013-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: MIT
 */

import {readFile, writeFile} from 'node:fs/promises';

import Config from '../Config.mts';
import clean, {isEncrypted} from '../clean.mts';
import commonOptions from '../commonOptions.mts';
import git from '../git.mts';
import * as log from '../log.mts';
import markdown from '../markdown.mts';
import smudge from '../smudge.mts';

import type {Secrets} from '../Config.mts';

export const description = 'merge driver for encrypted files';

export const documentation = await markdown('git-cipher-merge');

export async function execute(invocation: Invocation): Promise<number> {
  if (invocation.args.length !== 5) {
    log.error(`expected 5 arguments, got: ${invocation.args.join(' ')}`);
    return 1;
  }
  const ancestor = invocation.args[0]!; // Temporary file.
  const ours = invocation.args[1]!; // Temporary file.
  const theirs = invocation.args[2]!; // Temporary file.
  const markerSize = invocation.args[3]!; // Positive integer (default 7).
  const pathname = invocation.args[4]!; // In worktree.

  const config = new Config();

  const secrets = await config.readPrivateSecrets();
  if (!secrets) {
    log.error(
      'git-cipher merge driver cannot operate without secrets; do you need to run `git-cipher unlock`?',
    );
    return 0;
  }

  await decrypt(ancestor, secrets, pathname);
  await decrypt(ours, secrets, pathname);
  await decrypt(theirs, secrets, pathname);

  // May want to produce better labels than these by passing `-L`:
  //
  //   <<<<<<< .merge_file_8GZVCp
  //   contents on their branch
  //   ||||||| .merge_file_js3M4D
  //   content at base
  //   =======
  //   contents on our branch
  //   >>>>>>> .merge_file_5MeZof
  //
  const result = await git(
    'merge-file',
    `--marker-size=${markerSize}`,
    ours,
    ancestor,
    theirs,
  );
  if (!result.success) {
    // User will have to do manual merge.
    return 1;
  }

  await encrypt(ours, secrets, pathname);

  return 0;
}

async function encrypt(
  filename: string,
  secrets: Secrets,
  pathname: string,
): Promise<void> {
  const input = await readFile(filename);

  if (!input.length) {
    log.debug(`file ${filename} is empty; doing nothing`);
    return;
  }

  if (isEncrypted(input)) {
    log.info(`${filename} is already encrypted; doing nothing`);
    return;
  }

  // `filename` is a temporary file provided by Git, but encryption depends on
  // the real path in the worktree (specifically, to produce the IV and
  // HMAC), so we pass in `pathname` instead.
  const encrypted = await clean(input, pathname, secrets);

  await writeFile(filename, encrypted);
}

async function decrypt(
  filename: string,
  secrets: Secrets,
  pathname: string,
): Promise<void> {
  const input = await readFile(filename);

  if (!input.length) {
    log.debug(`file ${filename} is empty; passing through`);
    return;
  }

  // `filename` is a temporary file provided by Git, but decryption depends on
  // the real path in the worktree (specifically, to verify the HMAC), so we
  // pass in `pathname` instead.
  const plaintext = await smudge(input, pathname, secrets);
  await writeFile(filename, plaintext);
}

export const optionsSchema = {
  ...commonOptions,
} as const;
