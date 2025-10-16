/**
 * SPDX-FileCopyrightText: Copyright 2013-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: MIT
 */

import {Buffer} from 'node:buffer';

import {
  BLOCK_CIPHER_ALGORITHM,
  PROTOCOL_URL,
  PROTOCOL_VERSION,
  encrypt,
  generateFileSalt,
  mac,
} from './crypto.mts';
import hex from './hex.mts';

import type {Secrets} from './Config.mts';

/**
 * Core of the "clean" (ie. encryption) process.
 *
 * Extracted here so it can be used by both the `clean` and `merge`
 * subcommands.
 */
export default async function clean(
  input: Buffer,
  filename: string,
  secrets: Secrets,
): Promise<string> {
  const authenticationKey = Buffer.from(secrets.authenticationKey, 'hex');
  const encryptionKey = Buffer.from(secrets.encryptionKey, 'hex');
  const salt = Buffer.from(secrets.salt, 'hex');
  const iv = await generateFileSalt(filename, input, salt);
  const ciphertext = await encrypt(input, encryptionKey, iv);
  const hmac = await mac(filename, iv, ciphertext, authenticationKey);

  return (
    'magic = dev.wincent.git-cipher\n' +
    `url = ${PROTOCOL_URL}\n` +
    `version = ${PROTOCOL_VERSION}\n` +
    'algorithm = ' +
    BLOCK_CIPHER_ALGORITHM +
    '\n' +
    'filename = ' +
    JSON.stringify(filename) +
    '\n' +
    'iv = ' +
    hex(iv) +
    '\n' +
    'ciphertext =\n' +
    hex(ciphertext) +
    '\n' +
    'hmac = ' +
    hex(hmac) +
    '\n'
  );
}

// What we use to detect already-encrypted files.
const MAGIC_REGEXP = /\s*\bmagic\s*=\s*(com|dev)\.wincent\.git-cipher\b\s*/;

// How far into the file we look to find the magic header.
const MAGIC_SEARCH_LIMIT = 200;

export function isEncrypted(input: Buffer): boolean {
  return MAGIC_REGEXP.test(input.subarray(0, MAGIC_SEARCH_LIMIT).toString());
}
