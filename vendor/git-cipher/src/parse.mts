/**
 * SPDX-FileCopyrightText: Copyright 2013-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: MIT
 */

import Scanner from './Scanner.mts';
import {BLOCK_CIPHER_HMAC_SIZE, BLOCK_CIPHER_IV_SIZE} from './crypto.mts';

type ParseResult = AlreadyDecrypted | ParseError | ParseSuccess;

type AlreadyDecrypted = {
  kind: 'already-decrypted';
};

type ParseError = {
  kind: 'error';
  description: string;
};

type ParseSuccess = {
  kind: 'success';
  ciphertext: Buffer;
  filename: string;
  hmac: Buffer;
  iv: Buffer;
  version: 1 | 2;
};

/**
 * Parse an input Buffer containing an encrypted payload into structured form.
 */
export default function parse(input: Buffer): ParseResult {
  const tokens: {
    ciphertext: string;
    filename: string | undefined;
    hmac: string | undefined;
    iv: string | undefined;
  } = {
    ciphertext: '',
    filename: undefined,
    hmac: undefined,
    iv: undefined,
  };

  const scanner = new Scanner(input.toString('utf8'));
  if (!scanner.scan(/\s*magic\s*=\s*(com|dev)\.wincent\.git-cipher\s*/)) {
    return {kind: 'already-decrypted'};
  }

  let version: 1 | 2 | undefined;
  let lastIndex = scanner.index;
  while (!scanner.atEnd()) {
    scanner.scan(/\s*url\s*=\s*[^\n]+\s*/); // Informational only; ignore.

    if (scanner.scan(/\s*version\s*=\s*/)) {
      const versionString = scanner.scan(/\d+/);
      if (versionString === '1') {
        version = 1;
      } else if (versionString === '2') {
        version = 2;
      } else {
        return {
          kind: 'error',
          description: `unrecognized version ${versionString}`,
        };
      }
    }

    scanner.scan(/\s*/);

    if (scanner.scan(/\s*algorithm\s*=\s*/)) {
      const algorithm = scanner.scan(/[a-z0-9-]+/);
      if (algorithm !== 'aes-256-cbc') {
        return {
          kind: 'error',
          description: `unrecognized algorithm ${algorithm}`,
        };
      }
    }

    // Informational only.
    // The `iv` field is derived from the filename and is the one that actually
    // matters; having the filename here can be useful as a debugging aid,
    // though, to detect things like a `git mv` of an encrypted file.
    if (scanner.scan(/\s*filename\s*=\s*/)) {
      tokens.filename = scanner.scan(/[^\n]+/);
      try {
        tokens.filename = JSON.parse(tokens.filename!.trimEnd());
      } catch {
        return {
          kind: 'error',
          description: `invalid filename ${tokens.filename}`,
        };
      }
    }

    if (scanner.scan(/\s*iv\s*=\s*/)) {
      tokens.iv = scanner.scan(/[a-f0-9]+/);
      if (tokens.iv?.length !== BLOCK_CIPHER_IV_SIZE * 2) {
        return {
          kind: 'error',
          description: `invalid IV ${tokens.iv}`,
        };
      }
    }

    scanner.scan(/\s*/);

    if (scanner.scan(/\s*ciphertext\s*=\s*/)) {
      while (!scanner.atEnd()) {
        const chunk = scanner.scan(/[a-f0-9]+/);
        if (chunk) {
          tokens.ciphertext += chunk;
          scanner.scan(/\s*/);
        } else {
          break;
        }
      }
    }

    scanner.scan(/\s*/);

    if (scanner.scan(/\s*hmac\s*=\s*/)) {
      tokens.hmac = scanner.scan(/[a-f0-9]+/);
      if (tokens.hmac?.length !== BLOCK_CIPHER_HMAC_SIZE * 2) {
        return {
          kind: 'error',
          description: `invalid HMAC ${tokens.hmac}`,
        };
      }
    }

    scanner.scan(/\s*/);

    if (scanner.index === lastIndex) {
      return {
        kind: 'error',
        description: `failed to consume input at index ${lastIndex}`,
      };
    }

    lastIndex = scanner.index;
  }

  if (!tokens.ciphertext.length) {
    return {
      kind: 'error',
      description: 'failed to scan ciphertext',
    };
  }
  if (tokens.filename === undefined) {
    return {
      kind: 'error',
      description: 'failed to scan filename',
    };
  }
  if (tokens.hmac === undefined) {
    return {
      kind: 'error',
      description: 'failed to scan HMAC',
    };
  }
  if (tokens.iv === undefined) {
    return {
      kind: 'error',
      description: 'failed to scan IV',
    };
  }

  return {
    kind: 'success',
    ciphertext: Buffer.from(tokens.ciphertext, 'hex'),
    filename: tokens.filename,
    hmac: Buffer.from(tokens.hmac, 'hex'),
    iv: Buffer.from(tokens.iv, 'hex'),
    version: version || 2,
  };
}
