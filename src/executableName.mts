/**
 * SPDX-FileCopyrightText: Copyright 2013-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: MIT
 */

import {argv} from 'node:process';

export default function executableName(): string {
  // Sadly, at this point we can't know if called as `git cipher <subcommand>`
  // or `git-cipher <subcommand>` (ie. via $PATH) or `bin/git-cipher
  // <subcommand>` (ie. in `__DEV__` env); so we take a weak guess.
  if (argv[0]?.includes('/vendor/node/n/versions/node/')) {
    // Probably running from __DEV__ via `bin/git-cipher`; first two elements of
    // `argv` will resemble:
    //
    // - '/some/absolute/path/to/repo/vendor/node/n/versions/node/22.18.0/bin/node'
    // - '/some/absolute/path/to/repo/lib/main.mts'
    return 'git-cipher';
  } else {
    // Probably installed globally in `$PATH`.
    return 'git cipher';
  }
}
