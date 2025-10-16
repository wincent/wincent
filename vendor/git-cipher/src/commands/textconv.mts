/**
 * SPDX-FileCopyrightText: Copyright 2013-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: MIT
 */

import {Buffer} from 'node:buffer';
import {readFile} from 'node:fs/promises';
import {stdout} from 'node:process';

import Config from '../Config.mts';
import commonOptions from '../commonOptions.mts';
import {decrypt, verify} from '../crypto.mts';
import * as log from '../log.mts';
import markdown from '../markdown.mts';
import parse from '../parse.mts';

export const description = 'decrypts file contents for display in `git diff`';

export const documentation = await markdown('git-cipher-textconv');

export async function execute(invocation: Invocation): Promise<number> {
  if (invocation.args.length !== 1) {
    log.error(
      `expected exactly one filename argument, got: ${
        invocation.args.join(
          ' ',
        )
      }`,
    );
    return 1;
  }
  const filename = invocation.args[0]!;

  const config = new Config();

  const input = await readFile(filename);

  if (!input.length) {
    log.debug(`file ${filename} is empty; passing through`);
    return 0;
  }

  const payload = parse(input);
  if (payload.kind === 'already-decrypted') {
    log.info(`file ${filename} is already decrypted; passing through`);
    stdout.write(input);
    return 0;
  } else if (payload.kind === 'error') {
    log.error(payload.description);
    return 1;
  }

  if (payload.filename !== filename) {
    log.warn(
      `payload filename (${payload.filename}) does not match passed filename (${filename})`,
    );
  }

  const secrets = await config.readPrivateSecrets();
  if (!secrets) {
    log.debug(
      'cannot do textconv without secrets; do you need to run `git-cipher unlock`?',
    );
    stdout.write(input);
    return 0;
  }

  const authenticationKey = Buffer.from(secrets.authenticationKey, 'hex');
  const encryptionKey = Buffer.from(secrets.encryptionKey, 'hex');

  const {ciphertext, hmac, iv} = payload;

  const valid = await verify(hmac, filename, iv, ciphertext, authenticationKey);
  if (!valid) {
    log.error('HMAC verification failed');
    return 1;
  }
  const plaintext = await decrypt(ciphertext, encryptionKey, iv);

  stdout.write(plaintext);

  return 0;
}

export const optionsSchema = {
  ...commonOptions,
} as const;
