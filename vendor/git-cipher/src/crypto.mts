/**
 * SPDX-FileCopyrightText: Copyright 2013-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: MIT
 */

import {Buffer} from 'node:buffer';
import {promisify} from 'node:util';
const {
  createCipheriv,
  createDecipheriv,
  createHmac,
  randomFill: randomFillAsync,
  scrypt,
} = await import('node:crypto');

const randomFill = promisify(randomFillAsync);

export const PROTOCOL_URL =
  `https://github.com/wincent/git-cipher/blob/main/PROTOCOL.md`;
export const PROTOCOL_VERSION = 2;
export const BLOCK_CIPHER_ALGORITHM = 'aes-256-cbc';

export const BLOCK_CIPHER_HMAC_SIZE = 32; // 32 bytes = 256 bits.
export const BLOCK_CIPHER_IV_SIZE = 16; // 16 bytes = 128 bits = block size.
export const BLOCK_CIPHER_KEY_SIZE = 32; // 32 bytes = 256 bits.

/**
 * Size of the `salt` parameter to `scrypt()`.
 *
 * Should be "at least 128 bits" (ie. 16 bytes):
 *
 * https://nvlpubs.nist.gov/nistpubs/Legacy/SP/nistspecialpublication800-132.pdf
 */
const KEY_SALT_SIZE = 64; // 64 bytes = 512 bits.

export async function decrypt(
  contents: Buffer,
  key: Buffer,
  iv: Buffer,
): Promise<Buffer> {
  return new Promise((resolve, _reject) => {
    const decipher = createDecipheriv(BLOCK_CIPHER_ALGORITHM, key, iv);
    const initial = decipher.update(contents);
    const final = decipher.final();
    resolve(Buffer.concat([initial, final]));
  });
}

export async function deriveKey(
  passphrase: Buffer,
  salt: Buffer,
): Promise<Buffer> {
  return new Promise((resolve, reject) => {
    scrypt(passphrase, salt, BLOCK_CIPHER_KEY_SIZE, (error, buffer) => {
      if (error) {
        reject(error);
      } else {
        resolve(buffer);
      }
    });
  });
}

export async function encrypt(
  contents: Buffer,
  key: Buffer,
  iv: Buffer,
): Promise<Buffer> {
  return new Promise((resolve, _reject) => {
    const cipher = createCipheriv(BLOCK_CIPHER_ALGORITHM, key, iv);
    const initial = cipher.update(contents);
    const final = cipher.final();
    resolve(Buffer.concat([initial, final]));
  });
}

/**
 * Compares two equal-length buffers without short-circuiting on the first
 * mismatch. The time taken to return `true`/`false` should be roughly
 * proportional to the length of the buffers rather than to the length of the
 * matching prefix.
 *
 * See: https://codahale.com/a-lesson-in-timing-attacks/
 */
function equal(a: Buffer, b: Buffer): boolean {
  if (a.length !== b.length) {
    return false;
  }
  let differences = 0;
  for (let i = 0; i < a.length; i++) {
    differences = differences | (a[i]! ^ b[i]!);
  }
  return differences === 0;
}

/**
 * We use these deterministic per-file "file salts" as IVs in the block cipher
 * (in order to get deterministic encryption). `base` is a one-time secret
 * generated separately from the passphrase.
 *
 * The IV itself is not secret, but in order to attack it, you'd need to know
 * the filename (easy), guess the file contents (sometimes), _and_ guess the
 * `base` (hard). Basically you would brute force, creating HMACs for the
 * suspected file contents until you guessed `base` (which are 32 bytes from a
 * cryptographic random source).
 *
 * Once you know the `base`, however, that tells you nothing about the
 * `passphrase`. In other words, you did a lot of work to guess something that
 * won't prove very valuable compared to what you already know (you already
 * guessed the file contents, after all).
 */
export async function generateFileSalt(
  filename: string,
  contents: Buffer,
  base: Buffer,
): Promise<Buffer> {
  return new Promise(async (resolve, _reject) => {
    const secret = Buffer.concat([base, Buffer.from(filename)]);
    const hmac = createHmac('sha256', secret);
    hmac.update(contents);
    const digest = hmac.digest();
    const salt = Buffer.concat([digest], BLOCK_CIPHER_IV_SIZE);
    resolve(salt);
  });
}

/**
 * This is totally random; we generate it once and record it for subsequent use.
 */
export async function generateKeySalt(): Promise<Buffer> {
  return generateRandom(KEY_SALT_SIZE);
}

export async function generateRandom(size: number = 32): Promise<Buffer> {
  const buffer = Buffer.alloc(size);
  await randomFill(buffer);
  return buffer;
}

export async function generateRandomPassphrase(
  size: number = 128,
): Promise<Buffer> {
  return generateRandom(size);
}

/**
 * This is the "mac" in "encrypt-then-mac".
 *
 * For why we use a different key for this, than we do for salt/IV generation,
 * see:
 *
 * https://crypto.stackexchange.com/a/8086
 */
export async function mac(
  filename: string,
  iv: Buffer,
  ciphertext: Buffer,
  key: Buffer,
): Promise<Buffer> {
  return new Promise(async (resolve, _reject) => {
    const secret = Buffer.concat([key, Buffer.from(filename)]);
    const hmac = createHmac('sha256', secret);
    const contents = Buffer.concat([iv, ciphertext]);
    hmac.update(contents);
    const digest = hmac.digest();
    resolve(digest);
  });
}

/**
 * The counterpart to `mac()`, you call this before decrypting to rule out
 * tampering.
 */
export async function verify(
  digest: Buffer,
  filename: string,
  iv: Buffer,
  ciphertext: Buffer,
  key: Buffer,
): Promise<boolean> {
  const actual = await mac(filename, iv, ciphertext, key);
  return equal(digest, actual);
}
