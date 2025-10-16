/**
 * SPDX-FileCopyrightText: Copyright 2013-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: MIT
 */

import {open} from 'node:fs/promises';
import {join, relative, resolve} from 'node:path';

import Config from '../Config.mts';
import commonOptions from '../commonOptions.mts';
import git from '../git.mts';
import * as log from '../log.mts';
import markdown from '../markdown.mts';
import {describeResult} from '../run.mts';

export const description = 'adds file(s) to set of encrypted files';

export const documentation = await markdown('git-cipher-add');

export async function execute(invocation: Invocation): Promise<number> {
  if (!invocation.args.length) {
    log.error(`\`git-cipher add\` expects one or more files to add`);
    return 1;
  }

  const config = new Config();

  const topLevel = await config.topLevel();
  if (!topLevel) {
    log.error('cannot do `add` operation without top-level');
    return 1;
  }

  const initialized = await config.isInitialized();
  if (!initialized) {
    log.error(
      'repository is not properly initialized; have you run `git cipher init`?',
    );
    return 1;
  }

  const unlocked = await config.isUnlocked();
  if (!unlocked) {
    log.error('repository is not unlocked; have you run `git cipher unlock`?');
    return 1;
  }

  // Note: these are relative to the top-level.
  const managedFiles = await config.managedFiles();
  if (!managedFiles) {
    log.warn('proceeding without list of managed files');
  }

  // BUG: if you run `git-cipher add foo` twice, line will be added twice
  // if you run it once, then `git add foo`, then run it again, it won't be
  // added a second time; this is because of how we ask Git our question, and
  // Git is only going to tell us about tracked files
  // TODO: see if `git ls-files --others` would help here (would have to invoke
  // it separately, because with `--others`, we don't show tracked files)

  const filesToAdd = [];
  const managedFilesSet = new Set(managedFiles);
  for (const file of invocation.args) {
    // TODO: if argument is not a file but a directory, add recursively? (or at least error)
    const normalized = relative(topLevel, resolve(file));
    if (managedFilesSet.has(normalized)) {
      log.info(`file ${file} is already managed by git-cipher`);
      // TODO: freshen definition... in case it is missing some fields
    } else {
      // TODO: confirm that this is actually a file (ie. existing, not a directory)
      log.info(`file ${file} is not yet managed by git-cipher`);
      filesToAdd.push(normalized);
    }
  }

  const output = filesToAdd
    .map(
      (file) =>
        `${
          quotePath(
            file,
          )
        }\tdiff=git-cipher\tfilter=git-cipher\tmerge=git-cipher\n`,
    )
    .join('');

  // A racy check to see whether the file already has a final newline is better
  // than no check at all.
  const gitattributes = await open(join(topLevel, '.gitattributes'), 'as+');
  const stat = await gitattributes.stat();
  let needsNewline = false;
  if (stat.size) {
    const data = await gitattributes.read({
      length: 1,
      position: stat.size - 1,
    });
    if (data.bytesRead && data.buffer[0] !== '\n'.charCodeAt(0)) {
      needsNewline = true;
    }
  }

  await gitattributes.appendFile(needsNewline ? `\n${output}` : output);

  if (filesToAdd.length) {
    const result = await git('add', '-N', '--', ...filesToAdd);
    if (!result.success) {
      log.error(describeResult(result));
    }
  }

  return 0;
}

function quotePath(path: string): string {
  const escaped = path.replace(/\\/g, '\\\\').replace(/"/g, '\\"');

  if (escaped === path && !path.includes(' ')) {
    return path;
  } else {
    return `"${escaped}"`;
  }
}

export const optionsSchema = {
  ...commonOptions,
} as const;
