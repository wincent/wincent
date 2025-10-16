/**
 * SPDX-FileCopyrightText: Copyright 2013-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: MIT
 */

const commonOptions = {
  '--debug': {
    defaultValue: false,
    kind: 'switch',
    description: 'show debug information',
  },
  '--help': {
    defaultValue: false,
    kind: 'switch',
    description: 'show usage information and exit',
  },
  '--quiet': {
    defaultValue: false,
    kind: 'switch',
    description: 'reduce verbosity',
  },
  '--verbose': {
    defaultValue: false,
    kind: 'switch',
    description: 'increase verbosity',
  },
} as const;

export default commonOptions;
