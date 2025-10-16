/**
 * SPDX-FileCopyrightText: Copyright 2013-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: MIT
 */

import {rm} from 'node:fs/promises';
import {join} from 'node:path';

import git from './git.mts';
import * as log from './log.mts';
import {describeResult} from './run.mts';

import type {default as Config} from './Config.mts';

/**
 * Common to both `git-cipher lock` and `git-cipher unlock`, this function
 * resets the contents of the managed files in the worktree.
 *
 * When unlocking, the contents will be overwitten with plaintext.
 * When locking, the contents will be overwritten with ciphertext.
 *
 * Note that _which_ contents get written depend on prior configuration;
 * namely, that the `filter.git-cipher.smudge` setting is in place, and:
 *
 * - When unlocking, private secrets should be available in
 *   `.git/git-cipher/secrets.json`, causing us to write decrypted text.
 * - When locking, private secrets should have been removed from
 *   `.git/git-cipher/secrets.json`, causing us to write encrypted text.
 */
export default async function resetManagedFiles(
  config: Config,
  invocation: Invocation,
): Promise<number> {
  const managedFiles = await config.managedFiles();
  if (!managedFiles) {
    log.error('could not determine managed files');
    return 1;
  }
  const topLevel = await config.topLevel();
  if (!topLevel) {
    log.error('cannot remove files without knowing top-level');
    return 1;
  }

  const hasDirtyWorktree = await config.hasDirtyWorktree();
  if (hasDirtyWorktree) {
    if (invocation.options['--force']) {
      log.notice('dirty worktree but resetting anyway due to --force');
    } else {
      log.error(
        'aborting because of dirty worktree; to proceed anyway use --force',
      );
      return 1;
    }
  } else if (hasDirtyWorktree === null) {
    log.error('cannot determine worktree status; aborting');
    return 1;
  }

  for (const file of managedFiles) {
    const absolute = join(topLevel, file);
    log.debug(`removing ${absolute}`);
    await rm(absolute, {force: true});
  }

  // Don't do force checkout unless there actually _are_ unmanaged files,
  // otherwise it will blow away _all_ uncommitted changes in worktree.
  if (managedFiles.length) {
    log.debug(`checking out ${managedFiles.join(', ')}`);
    const result = await git(
      '-C',
      topLevel,
      'checkout',
      '--force',
      'HEAD',
      '--',
      ...managedFiles,
    );
    if (!result.success) {
      log.error(describeResult(result));
      return 1;
    }
  }

  return 0;
}
