/**
 * SPDX-FileCopyrightText: Copyright 2013-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: MIT
 */

import {decrypt, verify} from './crypto.mts';
import * as log from './log.mts';
import parse from './parse.mts';

import type {Secrets} from './Config.mts';

type SmudgeOptions = {
  checkFilename?: boolean;
};

/**
 * Core of the "smudge" (ie. decryption) process.
 *
 * Extracted here so it can be used by both the `smudge` and `merge`
 * subcommands.
 */
export default async function smudge(
  input: Buffer,
  filename: string,
  secrets: Secrets,
  options?: SmudgeOptions,
): Promise<Buffer> {
  const authenticationKey = Buffer.from(secrets.authenticationKey, 'hex');
  const encryptionKey = Buffer.from(secrets.encryptionKey, 'hex');

  const payload = parse(input);
  if (payload.kind === 'already-decrypted') {
    return input;
  } else if (payload.kind === 'error') {
    log.error(payload.description);
    return input;
  }

  // May want to make logging optional because filename is sometimes a
  // temporary file.
  if (payload.filename !== filename && options?.checkFilename !== false) {
    log.warn(
      `payload filename (${payload.filename}) does not match passed filename (${filename})`,
    );
  }

  const {ciphertext, hmac, iv} = payload;

  const valid = await verify(hmac, filename, iv, ciphertext, authenticationKey);

  if (!valid) {
    log.error('HMAC verification failed');
    return input;
  }

  return decrypt(ciphertext, encryptionKey, iv);
}
