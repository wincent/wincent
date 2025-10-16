/**
 * SPDX-FileCopyrightText: Copyright 2013-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: MIT
 */

import {Buffer} from 'node:buffer';
import {spawn} from 'node:child_process';

import shellEscape from './shellEscape.mts';

export type Result = {
  command: string;
  error: Error | null;
  signal: string | null;
  status: number | null;
  stderr: Buffer;
  stdout: Buffer;
  success: boolean;
};

export type RunOptions = {
  stdin?: Buffer | string;
};

/**
 * Run a command and return the result.
 */
export default async function run(
  command: string,
  args: Array<string>,
  options?: RunOptions,
): Promise<Result> {
  return new Promise((resolve) => {
    const result: Result = {
      command: [command, ...args]
        .map((arg) => {
          return shellEscape(arg) || arg;
        })
        .join(' '),
      error: null,
      signal: null,
      status: null,
      stderr: Buffer.alloc(0),
      stdout: Buffer.alloc(0),
      success: false,
    };

    const child = spawn(command, args);

    if (options?.stdin) {
      child.stdin.write(options.stdin);
      child.stdin.end();
    }

    child.stderr.on('data', (data) => {
      result.stderr = Buffer.concat([result.stderr, data]);
    });

    // "The 'close' event is emitted after a process has ended and the stdio
    // streams of a child process have been closed. This is distinct from
    // the 'exit' event, since multiple processes might share the same stdio
    // streams. The 'close' event will always emit after 'exit' was already
    // emitted, or 'error' if the child failed to spawn."
    //
    // See: https://nodejs.org/api/child_process.html#event-close
    child.on('close', () => {
      result.success = result.error === null && result.signal === null &&
        result.status === 0;
      resolve(result);
    });

    child.stdout.on('data', (data) => {
      result.stdout = Buffer.concat([result.stdout, data]);
    });

    // "The 'exit' event may or may not fire after an error has occurred. When
    // listening to both the 'exit' and 'error' events, guard against
    // accidentally invoking handler functions multiple times."
    //
    // See: https://nodejs.org/api/child_process.html#event-close
    child.on('error', (error) => {
      result.error = error;
    });

    // "The 'exit' event is emitted after the child process ends. If the process
    // exited, code is the final exit code of the process, otherwise null. If
    // the process terminated due to receipt of a signal, signal is the string
    // name of the signal, otherwise null. One of the two will always be
    // non-null.
    //
    // When the 'exit' event is triggered, child process stdio streams might
    // still be open."
    //
    // See: https://nodejs.org/api/child_process.html#event-exit
    child.on('exit', (status, signal) => {
      if (typeof status === 'number') {
        result.status = status;
      } else if (signal) {
        result.signal = signal;
      }
    });
  });
}

export function describeResult(result: Result, verbose: boolean = true) {
  if (result.success) {
    return 'success';
  }

  let description = `\`${result.command}\``;
  if (result.error) {
    description += ` failed with error ${result.error}`;
  } else if (result.signal) {
    description += ` exited due to signal ${result.signal}`;
  } else if (result.status) {
    description += ` exited with status ${result.status}`;
  }

  if (verbose && result.stderr.length) {
    description += `\n${result.stderr.toString()}`;
  }

  return description;
}
