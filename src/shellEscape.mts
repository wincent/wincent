/**
 * SPDX-FileCopyrightText: Copyright 2013-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: MIT
 */

const SHELL_SAFE_REGEX = /^[a-z0-9/_.-]+$/i;

const SHELL_SAFE_IF_QUOTED_REGEX = /^[^\\']+$/;

/**
 * Returns a shell-safe version of the provided `input`.
 *
 * If the `input` contains backslashes or single quotes, escaping in a
 * universally valid and safe way is tricky, so we just return `null`.
 */
export default function shellEscape(input: string): string | null {
  if (SHELL_SAFE_REGEX.test(input)) {
    return input;
  } else if (SHELL_SAFE_IF_QUOTED_REGEX.test(input)) {
    return `'${input}'`;
  } else {
    return null;
  }
}
