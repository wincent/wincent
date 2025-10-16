#!/usr/bin/env node

/**
 * SPDX-FileCopyrightText: Copyright 2013-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: MIT
 */

import assert from 'node:assert';
import {argv, exit} from 'node:process';

import ExitStatus from './ExitStatus.mts';
import * as log from './log.mts';
import parseOptions from './parseOptions.mts';

const invocation: Invocation = {
  options: {},
  args: [],
  argv: argv.slice(2),
};

const SHORT_SWITCH = /^-[a-z]$/i;
const SEPARATOR = '--';
const LONG_SWITCH = /^--(?:no-)?(?:[a-z]+-)*(?:[a-z]+)$/;
const LONG_OPTION = /^--(?:[a-z]+-)*(?:[a-z]+)=.+$/;

// Skip `node` executable + the `main.mts` script.
for (let i = 2; i < argv.length; i++) {
  const arg = argv[i];
  assert(arg);
  if (arg === SEPARATOR) {
    invocation.args.push(...argv.slice(i + 1));
    break;
  }

  let match = arg.match(SHORT_SWITCH);
  if (match) {
    invocation.options[arg] = true;
    continue;
  }

  match = arg.match(LONG_SWITCH);
  if (match) {
    if (arg.startsWith('--no-')) {
      invocation.options[`--${arg.slice(5)}`] = false;
    } else {
      invocation.options[arg] = true;
    }
    continue;
  }

  match = arg.match(LONG_OPTION);
  if (match) {
    const [option, value] = arg.split('=', 2);
    assert(option);
    assert(value);
    invocation.options[option] = value;
    continue;
  }

  if (!invocation.command) {
    invocation.command = arg;
  } else {
    invocation.args.push(arg);
  }
}

if (!invocation.command) {
  // Act as if user had run `git cipher help`.
  invocation.command = 'help';

  if (invocation.options['--help']) {
    // But don't show help for `help`; user has to run `git cipher help --help`
    // explicitly if they want that.
    delete invocation.options['--help'];
  }
}

// Note that some subcommands might want to override this (for example
// `clean`/`smudge` should probably be quieter by default than `init` or
// `unlock` which should be reasonably loud by default).
if (invocation.options['--quiet']) {
  log.setLogLevel(log.NOTICE);
}

if (invocation.options['--debug']) {
  log.setLogLevel(log.DEBUG);
}

// TODO: based on subcommand, parse/validate options/args
let status = 1;

try {
  // TODO: if these end up being all the same (and they probably will, look at
  // DRY-ing them up) - will lose type information unless i take steps
  // See: https://github.com/microsoft/TypeScript/issues/32401
  if (invocation.command === 'add') {
    const {execute, optionsSchema} = await import('./commands/add.mts');
    invocation.options = await parseOptions(invocation, optionsSchema);
    status = await execute(invocation);
  } else if (invocation.command === 'clean') {
    const {execute, optionsSchema} = await import('./commands/clean.mts');
    invocation.options = await parseOptions(invocation, optionsSchema);
    status = await execute(invocation);
  } else if (invocation.command === 'demo') {
    const {execute, optionsSchema} = await import('./commands/demo.mts');
    invocation.options = await parseOptions(invocation, optionsSchema);
    status = await execute(invocation);
  } else if (invocation.command === 'diff') {
    const {execute, optionsSchema} = await import('./commands/diff.mts');
    invocation.options = await parseOptions(invocation, optionsSchema, {
      wrapGit: true,
    });
    status = await execute(invocation);
  } else if (invocation.command === 'help') {
    const {execute, optionsSchema} = await import('./commands/help.mts');
    invocation.options = await parseOptions(invocation, optionsSchema);
    status = await execute(invocation);
  } else if (invocation.command === 'hook') {
    const {execute, optionsSchema} = await import('./commands/hook.mts');
    invocation.options = await parseOptions(invocation, optionsSchema);
    status = await execute(invocation);
  } else if (invocation.command === 'init') {
    const {execute, optionsSchema} = await import('./commands/init.mts');
    invocation.options = await parseOptions(invocation, optionsSchema);
    status = await execute(invocation);
  } else if (invocation.command === 'is-encrypted') {
    const {execute, optionsSchema} = await import(
      './commands/is-encrypted.mts'
    );
    invocation.options = await parseOptions(invocation, optionsSchema);
    status = await execute(invocation);
  } else if (invocation.command === 'lock') {
    const {execute, optionsSchema} = await import('./commands/lock.mts');
    invocation.options = await parseOptions(invocation, optionsSchema);
    status = await execute(invocation);
  } else if (invocation.command === 'log') {
    const {execute, optionsSchema} = await import('./commands/log.mts');
    invocation.options = await parseOptions(invocation, optionsSchema, {
      wrapGit: true,
    });
    status = await execute(invocation);
  } else if (invocation.command === 'ls') {
    const {execute, optionsSchema} = await import('./commands/ls.mts');
    invocation.options = await parseOptions(invocation, optionsSchema);
    status = await execute(invocation);
  } else if (invocation.command === 'merge') {
    const {execute, optionsSchema} = await import('./commands/merge.mts');
    invocation.options = await parseOptions(invocation, optionsSchema);
    status = await execute(invocation);
  } else if (invocation.command === 'show') {
    const {execute, optionsSchema} = await import('./commands/show.mts');
    invocation.options = await parseOptions(invocation, optionsSchema, {
      wrapGit: true,
    });
    status = await execute(invocation);
  } else if (invocation.command === 'smudge') {
    const {execute, optionsSchema} = await import('./commands/smudge.mts');
    invocation.options = await parseOptions(invocation, optionsSchema);
    status = await execute(invocation);
  } else if (invocation.command === 'textconv') {
    const {execute, optionsSchema} = await import('./commands/textconv.mts');
    invocation.options = await parseOptions(invocation, optionsSchema);
    status = await execute(invocation);
  } else if (invocation.command === 'unlock') {
    const {execute, optionsSchema} = await import('./commands/unlock.mts');
    invocation.options = await parseOptions(invocation, optionsSchema);
    status = await execute(invocation);
  } else {
    log.error(`command not implemented: ${invocation.command}`);
  }
} catch (error) {
  if (error instanceof ExitStatus) {
    status = error.status;
  } else {
    throw error;
  }
}

exit(status);
