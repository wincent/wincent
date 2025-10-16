/**
 * SPDX-FileCopyrightText: Copyright 2013-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: MIT
 */

import assert from 'node:assert';
import {chmod, mkdir, open, readFile} from 'node:fs/promises';
import {join} from 'node:path';

import Config from '../Config.mts';
import {isErrnoException} from '../assert.mts';
import commonOptions from '../commonOptions.mts';
import {
  PROTOCOL_URL,
  PROTOCOL_VERSION,
  deriveKey,
  generateKeySalt,
  generateRandom,
  generateRandomPassphrase,
} from '../crypto.mts';
import dedent from '../dedent.mts';
import gpg from '../gpg.mts';
import hex from '../hex.mts';
import * as log from '../log.mts';
import markdown from '../markdown.mts';
import {describeResult} from '../run.mts';

export const description = 'prepares a repository to work with git-cipher';

export const documentation = await markdown('git-cipher-init');

export async function execute(invocation: Invocation): Promise<number> {
  const config = new Config();

  if ((await config.topLevel()) === null) {
    log.error('unable to determine repository top-level directory');
    return 1;
  }

  const publicDirectory = await config.publicDirectory();
  assert(publicDirectory);
  await mkdir(publicDirectory, {recursive: true});

  // Grab existing secrets if we're in a `git-cipher unlock`-ed repository.
  let secrets = await (async () => {
    try {
      const secrets = await config.readPrivateSecrets();
      if (secrets) {
        log.notice('preserving existing secrets');
        return JSON.stringify(
          {
            ...secrets,
            url: PROTOCOL_URL,
            version: PROTOCOL_VERSION,
          },
          null,
          2,
        );
      } else {
        return null;
      }
    } catch {
      return null;
    }
  })();

  // Otherwise generate new secrets.
  if (!secrets) {
    log.warn('generating new secrets; these will REPLACE any existing secrets');
    const encryptionPassphrase = await generateRandomPassphrase();
    const encryptionKeySalt = await generateKeySalt();
    const encryptionKey = await deriveKey(
      encryptionPassphrase,
      encryptionKeySalt,
    );
    const authenticationPassphrase = await generateRandomPassphrase();
    const authenticationKeySalt = await generateKeySalt();
    const authenticationKey = await deriveKey(
      authenticationPassphrase,
      authenticationKeySalt,
    );
    const salt = await generateRandom();

    secrets = JSON.stringify(
      {
        authenticationKey: hex(authenticationKey, 0),
        encryptionKey: hex(encryptionKey, 0),
        salt: hex(salt, 0),
        url: PROTOCOL_URL,
        version: PROTOCOL_VERSION,
      },
      null,
      2,
    );
  }

  const defaultRecipients = optionsSchema['--recipients'].defaultValue;
  const passedRecipients = invocation.options['--recipients'];
  assert(typeof passedRecipients === 'string');
  if (passedRecipients === defaultRecipients) {
    log.warn(
      `using default --recipients value of ${defaultRecipients}; pass something else to override`,
    );
  }
  const recipients = optionsSchema['--recipients'].process(passedRecipients);

  let result = await gpg(
    '--armor',
    '--quiet',
    '--batch',
    '--no-tty',
    '--yes',
    ...recipients,
    '--output',
    '-',
    '--encrypt',
    {
      stdin: secrets,
    },
  );
  if (!result.success) {
    log.error(describeResult(result));
    return 1;
  }

  const publicSecretsPath = await config.publicSecretsPath();
  assert(publicSecretsPath);
  try {
    const mode = invocation.options['--force'] ? 'w' : 'wx';
    const file = await open(publicSecretsPath, mode);
    file.write(result.stdout);
  } catch (error) {
    if (isErrnoException(error) && error.code === 'EEXIST') {
      log.warn(
        `not writing ${publicSecretsPath} because it already exists; re-run with --force to overwrite`,
      );
    } else {
      log.error(`failed to write file ${publicSecretsPath}: ${error}`);
      return 1;
    }
  }

  if (!(await config.initConfig())) {
    return 1;
  }

  const hooksPath = await config.hooksPath();
  if (!hooksPath) {
    log.error('cannot determine hooks path');
    return 1;
  }

  const preCommitPath = join(hooksPath, 'pre-commit');
  const hookContents = dedent(`
    #!/bin/sh

    ${config.toolPath()} hook
  `);
  try {
    // Try to write but error if already exists.
    const file = await open(preCommitPath, 'wx');
    file.write(hookContents);
  } catch (error) {
    if (isErrnoException(error) && error.code === 'EEXIST') {
      // File already existed, was it different?
      const contents = await readFile(preCommitPath, {encoding: 'utf8'});
      if (contents !== hookContents) {
        log.error(
          `hook already exists at ${preCommitPath} with different contents; not overwriting`,
        );
        // TODO: offer to overwrite with --force
        return 0;
      }
    } else {
      log.error(`failed to write file ${preCommitPath}: ${error}`);
      return 1;
    }
  }

  // TODO: only do this if we created the file, or its contents match what we
  // want
  await chmod(preCommitPath, 0o755);

  return 0;
}

export const optionsSchema = {
  ...commonOptions,
  // '--passphrase': {
  //   kind: 'option',
  //   required: false,
  //   description: '',
  // },
  // '--passphrase-method': {
  //   allowedValues: ['arg', 'gpg', 'env', 'prompt'],
  //   defaultValue: 'gpg',
  //   kind: 'option',
  //   required: false,
  //   description: ''
  // },
  '--force': {
    defaultValue: false,
    kind: 'switch',
    required: false,
    description: 'overwrite existing secrets',
  },
  '--recipients': {
    defaultValue: 'greg@hurrell.net,greg.hurrell@datadoghq.com',
    kind: 'option',
    required: true,
    description: 'short description',
    process(value: string): Array<string> {
      return value.split(',').flatMap(
        // TODO: validate that recipients look like a GPG user id
        (recipient) => {
          return ['--recipient', recipient];
        },
      );
    },
  },
} as const;
