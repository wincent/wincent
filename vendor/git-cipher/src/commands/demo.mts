#!/usr/bin/env node

/**
 * SPDX-FileCopyrightText: Copyright 2013-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: MIT
 */

import {readFile} from 'node:fs/promises';

import commonOptions from '../commonOptions.mts';
import {
  BLOCK_CIPHER_ALGORITHM,
  PROTOCOL_URL,
  PROTOCOL_VERSION,
  decrypt,
  deriveKey,
  encrypt,
  generateFileSalt,
  generateKeySalt,
  generateRandom,
  generateRandomPassphrase,
  mac,
  verify,
} from '../crypto.mts';
import git from '../git.mts';
import hex from '../hex.mts';
import * as log from '../log.mts';
import markdown from '../markdown.mts';

export const description =
  'shows cryptographic primitives operating on sample data';

export const documentation = await markdown('git-cipher-demo');

export async function execute(invocation: Invocation): Promise<number> {
  const filename = invocation.args[0] || 'package.json';

  if (log.getLogLevel() < log.DEBUG) {
    log.info('Run with --debug to see intermediate results');
  }

  const passphrase = await generateRandomPassphrase();
  log.debug(`pass\n${hex(passphrase)}`);

  const authenticationKey = await generateRandom();
  log.debug(`authenticationKey\n${hex(authenticationKey)}`);

  const base = await generateRandom();
  log.debug(`base\n${hex(base)}`);

  const keySalt = await generateKeySalt();
  log.debug(`keySalt\n${hex(keySalt)}`);

  const derived = await deriveKey(passphrase, keySalt);
  log.debug(`derived (1 of 2)\n${hex(derived)}`);

  const derived2 = await deriveKey(passphrase, keySalt);
  log.debug(`derived (2 of 2)\n${hex(derived2)}`);

  log.debug(`filename ${filename}`);

  const contents = await readFile(filename);
  log.debug(`contents\n${hex(contents)}`);

  const salt = await generateFileSalt(filename, contents, base);
  log.debug(`salt (1 of 2) ${hex(salt)}`);

  const salt2 = await generateFileSalt(filename, contents, base);
  log.debug(`salt (2 of 2) ${hex(salt2)}`);

  const ciphertext = await encrypt(contents, derived, salt);
  log.debug(`ciphertext (1 of 2)\n${hex(ciphertext)}`);

  const ciphertext2 = await encrypt(contents, derived, salt);
  log.debug(`ciphertext (2 of 2)\n${hex(ciphertext2)}`);

  const theMac = await mac(filename, salt, ciphertext, authenticationKey);
  log.debug(`the mac\n${hex(theMac)}`);

  const verifies = await verify(
    theMac,
    filename,
    salt,
    ciphertext,
    authenticationKey,
  );
  log.debug(`verifies? ${verifies}`);

  const plaintext = await decrypt(ciphertext, derived, salt);
  log.debug(`plaintext (1 of 2)\n${hex(plaintext)}`);

  const plaintext2 = await decrypt(ciphertext, derived, salt);
  log.debug(`plaintext (1 of 2)\n${hex(plaintext2)}`);

  log.debug(plaintext.toString('utf8'));

  const cleaned = 'magic = dev.wincent.git-cipher\n' +
    `url = ${PROTOCOL_URL}\n` +
    `version = ${PROTOCOL_VERSION}\n` +
    'algorithm = ' +
    BLOCK_CIPHER_ALGORITHM +
    '\n' +
    'iv = ' +
    hex(salt) +
    '\n' +
    'ciphertext =\n' +
    hex(ciphertext) +
    '\n' +
    'hmac = ' +
    hex(theMac) +
    '\n';

  log.info(cleaned);

  const result = await git('rev-parse', '--git-dir');
  log.debug(result);
  log.debug(result.stdout.toString());

  return 0;
}

export const optionsSchema = {
  ...commonOptions,
} as const;
