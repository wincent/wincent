/**
 * SPDX-FileCopyrightText: Copyright 2013-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: MIT
 */

type Invocation = {
  command?: string;
  options: {[key: string]: boolean | string};
  args: Array<string>;

  /**
   * Original `process.argv`, minus the first two items.
   */
  argv: Array<string>;
};
