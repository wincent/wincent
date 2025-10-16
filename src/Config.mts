/**
 * SPDX-FileCopyrightText: Copyright 2013-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: MIT
 */

import assert from 'node:assert';
import {chmod, mkdir, readFile, rm, writeFile} from 'node:fs/promises';
import {join} from 'node:path';
import {env} from 'node:process';

import {assertHasKey, assertIsObject, isErrnoException} from './assert.mts';
import git from './git.mts';
import gpg from './gpg.mts';
import * as log from './log.mts';
import {bin} from './paths.mts';
import {describeResult} from './run.mts';
import shellEscape from './shellEscape.mts';

export type Secrets = {
  authenticationKey: string;
  encryptionKey: string;
  salt: string;
};

const __DEV__ = !!env['__DEV__'];

export default class Config {
  _gitDir?: string | null;
  _hooksPath?: string | null;
  _managedFiles?: Array<string> | null;
  _topLevel?: string | null;
  _untrackedManagedFiles?: Array<string> | null;

  async checkConfig(): Promise<Array<string>> {
    const errors = [];
    for (const [key, expected] of Object.entries(this.gitConfig())) {
      const result = await git('config', key);

      // Distinguish between low severity errors (like missing/incorrect values)
      // and high severity ones (invalid files, `git config` process problems)
      // which should be logged loudly and cause us to immediately `break`.
      if (result.status === 1) {
        errors.push(`no value for ${key}`);
      } else if (result.status === 3) {
        const error = 'config file is invalid';
        log.error(error);
        errors.push(error);
        break;
      } else if (!result.success) {
        const error = describeResult(result);
        log.error(error);
        errors.push(error);
        break;
      } else {
        const actual = result.stdout.toString().trim();
        if (actual !== expected) {
          errors.push(
            `value for ${key} (${actual}) does not match expected (${expected})`,
          );
        }
      }
    }
    return errors;
  }

  async decryptPublicSecrets(): Promise<Secrets | null> {
    const file = await this.readPublicSecrets();
    if (!file) {
      log.error('unable to read public secrets');
      return null;
    }
    const result = await gpg(
      '--quiet',
      '--yes',
      '--batch',
      '--no-tty',
      '--use-agent',
      '--output',
      '-',
      '--decrypt',
      {
        stdin: file,
      },
    );
    if (!result.success) {
      log.error(describeResult(result));
      return null;
    }
    const secrets = JSON.parse(result.stdout.toString());
    assertIsSecrets(secrets);
    return {
      authenticationKey: secrets.authenticationKey,
      encryptionKey: secrets.encryptionKey,
      salt: secrets.salt,
    };
  }

  /**
   * Returns Git directory, or `null` if it cannot be found.
   */
  async gitDir(): Promise<string | null> {
    if (this._gitDir === undefined) {
      const result = await git('rev-parse', '--git-dir');
      if (result.success) {
        const gitDir = result.stdout.toString().replace(/\n$/, '');
        // TODO: Confirm that it exists...
        this._gitDir = gitDir;
      } else {
        this._gitDir = null;
      }
    }
    return this._gitDir;
  }

  async hooksPath(): Promise<string | null> {
    if (this._hooksPath === undefined) {
      const result = await git('config', 'core.hooksPath');
      if (result.success) {
        this._hooksPath = result.stdout.toString();
      } else {
        const gitDir = await this.gitDir();
        if (gitDir) {
          this._hooksPath = join(gitDir, 'hooks');
        } else {
          this._hooksPath = null;
        }
      }
    }
    return this._hooksPath;
  }

  gitConfig(): {[name: string]: string} {
    const tool = this.toolPath();
    return {
      'diff.git-cipher.binary': 'true',
      'diff.git-cipher.cachetextconv': 'true',
      'diff.git-cipher.textconv': `${tool} textconv`,
      'filter.git-cipher.clean': `${tool} clean %f`,
      'filter.git-cipher.smudge': `${tool} smudge %f`,
      'merge.git-cipher.driver': `${tool} merge %O %A %B %L %P`,
      'merge.git-cipher.name':
        `git-cipher merge driver for merging encrypted files`,
      'merge.renormalize': 'true',
    };
  }

  async hasDirtyWorktree(): Promise<boolean | null> {
    let result = await git(
      'update-index',
      '-q', // Don't error if index needs an update.
      '--really-refresh', // Call `stat()` to see if merges/updates are needed.
    );
    if (!result.success) {
      log.error(describeResult(result));
      return null;
    }
    result = await git(
      'diff-index',
      '--quiet', // Don't want output, only exit code (1 = differences).
      'HEAD',
    );
    if (result.status === 1) {
      return true;
    } else if (result.status === 0) {
      return false;
    } else if (result.stderr.toString().includes('HEAD')) {
      // In a new repo with no commits yet; will see something like:
      //
      //   fatal: ambiguous argument 'HEAD': unknown revision or path not in the working tree.
      //
      // The string may be localized though, so our test has to be loose and may
      // not be 100% accurate; consider this to be equivalent to a dirty
      // worktree.
      return true;
    } else {
      log.error(describeResult(result));
      return null;
    }
  }

  /**
   * See also: `lockConfig()`, `unlockConfig()`.
   */
  async initConfig(): Promise<boolean> {
    let success = true;
    for (const [key, value] of Object.entries(this.gitConfig())) {
      const result = await git('config', key, value);
      if (!result.success) {
        log.error(describeResult(result));
        success = false;
      }
    }
    return success;
  }

  async isInitialized(): Promise<boolean> {
    const errors = await this.checkConfig();
    if (errors.length) {
      return false;
    }
    const secrets = await this.readPublicSecrets();
    if (!secrets) {
      return false;
    }
    return true;
  }

  async isUnlocked(): Promise<boolean> {
    const secrets = await this.readPrivateSecrets();
    return !!secrets;
  }

  /**
   * See also: `initConfig()`, `unlockConfig()`.
   */
  async lockConfig(): Promise<void> {
    const result = await git('config', 'filter.git-cipher.required', 'false');
    if (!result.success) {
      log.error(describeResult(result));
    }
  }

  /**
   * Returns a list of `git-cipher`-managed files, relative to the top-level.
   */
  async managedFiles(): Promise<Array<string> | null> {
    if (this._managedFiles === undefined) {
      const topLevel = await this.topLevel();
      if (!topLevel) {
        log.error(
          'unable to get managed files because could not determine top-level',
        );
        this._managedFiles = null;
      } else {
        const result = await git(
          '-C',
          topLevel,
          'ls-files',
          '-z',
          ':(attr:filter=git-cipher)',
        );
        if (result.success) {
          this._managedFiles = [];
          for (const file of result.stdout.toString().split('\0')) {
            // Git will emit trailing '\0' so we'll get one final empty file.
            if (file) {
              this._managedFiles.push(file);
            }
          }
        } else {
          log.error(describeResult(result));
          this._managedFiles = null;
        }
      }
    }
    return this._managedFiles;
  }

  async publicDirectory(): Promise<string | null> {
    const topLevel = await this.topLevel();
    if (topLevel) {
      return join(topLevel, '.git-cipher');
    } else {
      return null;
    }
  }

  async publicSecretsPath(): Promise<string | null> {
    const publicDirectory = await this.publicDirectory();
    if (publicDirectory) {
      return join(publicDirectory, 'secrets.json.asc');
    } else {
      return null;
    }
  }

  async privateDirectory(): Promise<string | null> {
    const gitDirectory = await this.gitDir();
    if (gitDirectory) {
      return join(gitDirectory, 'git-cipher');
    } else {
      return null;
    }
  }

  async privateSecretsPath(): Promise<string | null> {
    const privateDirectory = await this.privateDirectory();
    if (privateDirectory) {
      return join(privateDirectory, 'secrets.json');
    } else {
      return null;
    }
  }

  async readPublicSecrets(): Promise<Buffer | null> {
    const publicSecretsPath = await this.publicSecretsPath();
    assert(publicSecretsPath);
    try {
      const file = await readFile(publicSecretsPath);
      return file;
    } catch (error) {
      if (!isErrnoException(error) || error.code !== 'ENOENT') {
        throw error;
      }
      return null;
    }
  }
  async readPrivateSecrets(): Promise<Secrets | null> {
    const privateSecretsPath = await this.privateSecretsPath();
    assert(privateSecretsPath);
    log.debug(`reading ${privateSecretsPath}`);
    try {
      const secrets = await readFile(privateSecretsPath);
      const parsed = JSON.parse(secrets.toString());
      assertIsSecrets(parsed);
      return parsed;
    } catch (error) {
      if (!isErrnoException(error) || error.code !== 'ENOENT') {
        throw error;
      }
    }
    return null;
  }

  async removePrivateSecrets() {
    const privateSecretsPath = await this.privateSecretsPath();
    assert(privateSecretsPath);
    log.debug(`removing ${privateSecretsPath}`);
    try {
      await rm(privateSecretsPath);
    } catch (error) {
      if (isErrnoException(error) && error.code === 'ENOENT') {
        log.debug(`${privateSecretsPath} did not exist (ENOENT)`);
      } else {
        throw error;
      }
    }
  }

  toolPath(): string {
    return __DEV__
      ? shellEscape(join(bin, 'git-cipher')) || 'git-cipher'
      : 'git-cipher';
  }

  /**
   * Returns top level of the current Git repository.
   *
   * Returns `null` if repository is non-existent or bare.
   */
  async topLevel(): Promise<string | null> {
    if (this._topLevel === undefined) {
      const result = await git('rev-parse', '--show-toplevel');
      if (result.success) {
        this._topLevel = result.stdout.toString().replace(/\n$/, '');
      } else {
        this._topLevel = null;
      }
    }
    return this._topLevel;
  }

  /**
   * See also: `initConfig()`, `lockConfig()`.
   */
  async unlockConfig(): Promise<void> {
    const result = await git('config', 'filter.git-cipher.required', 'true');
    if (!result.success) {
      log.error(describeResult(result));
    }
  }

  async untrackedManagedFiles(): Promise<Array<string> | null> {
    if (this._untrackedManagedFiles === undefined) {
      const topLevel = await this.topLevel();
      if (!topLevel) {
        log.error(
          'unable to get untracked managed files because could not determine top-level',
        );
        this._untrackedManagedFiles = null;
      } else {
        const result = await git(
          '-C',
          topLevel,
          'ls-files',
          '-z',
          '--others',
          ':(attr:filter=git-cipher)',
        );
        if (result.success) {
          this._untrackedManagedFiles = [];
          for (const file of result.stdout.toString().split('\0')) {
            // Git will emit trailing '\0' so we'll get one final empty file.
            if (file) {
              this._untrackedManagedFiles.push(file);
            }
          }
        } else {
          log.error(describeResult(result));
          this._untrackedManagedFiles = null;
        }
      }
    }
    return this._untrackedManagedFiles;
  }
  async writePrivateSecrets(secrets: Secrets) {
    const privateDirectory = await this.privateDirectory();
    assert(privateDirectory);
    await mkdir(privateDirectory, {mode: 0o700, recursive: true});
    await chmod(privateDirectory, 0o700);
    const privateSecretsPath = await this.privateSecretsPath();
    assert(privateSecretsPath);
    await writeFile(
      privateSecretsPath,
      JSON.stringify(secrets, null, 2) + '\n',
      {mode: 0o600},
    );
    await chmod(privateSecretsPath, 0o600);
  }
}

function assertIsSecrets(value: unknown): asserts value is Secrets {
  // TODO: may want to assert more about this (format, length)
  assertIsObject(value);
  assertHasKey(value, 'authenticationKey');
  assertHasKey(value, 'encryptionKey');
  assertHasKey(value, 'salt');
  assert(typeof value.authenticationKey === 'string');
  assert(typeof value.encryptionKey === 'string');
  assert(typeof value.salt === 'string');
}
