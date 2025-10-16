/**
 * SPDX-FileCopyrightText: Copyright 2013-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: MIT
 */

import Config from '../Config.mts';
import commonOptions from '../commonOptions.mts';
import dedent from '../dedent.mts';
import git from '../git.mts';
import * as log from '../log.mts';
import markdown from '../markdown.mts';
import parse from '../parse.mts';
import {describeResult} from '../run.mts';
import shellEscape from '../shellEscape.mts';

export const description = 'Git pre-commit hook to detect encryption problems';

export const documentation = await markdown('git-cipher-hook');

export async function execute(invocation: Invocation): Promise<number> {
  if (invocation.args.length) {
    log.warn(`ignoring unexpected arguments: ${invocation.args.join(' ')}`);
  }

  const config = new Config();
  const files = await config.managedFiles();

  if (files === null) {
    return 1;
  }

  const bad = [];
  for (const file of files) {
    const result = await git('show', `:0:${file}`);
    if (!result.success) {
      log.error(describeResult(result));
      bad.push(file);
    } else if (result.stdout.length) {
      const parseResult = parse(result.stdout);
      if (parseResult.kind === 'already-decrypted') {
        log.error(`${file} in the Git index does not appear to be encrypted`);
        bad.push(file);
      } else if (parseResult.kind === 'error') {
        log.error(`${file} in the Git index is not validly encrypted`);
        bad.push(file);
      }
    }
  }

  if (!bad.length) {
    return 0;
  } else {
    const files = bad.map((file) => shellEscape(file) || file).join(' ');
    log.error(
      dedent(`
      To fix this, ensure that git-cipher is correctly configured in this repo:

          git-cipher init

      Then remove the files in question from the Git index:

          git rm --cached -- ${files}

      And re-stage them:

          git add -- ${files}

      To ignore this \`git-cipher hook\` message and commit anyway, use:

          git commit --no-verify
    `),
    );
    return 1;
  }
}

export const optionsSchema = {
  ...commonOptions,
} as const;
