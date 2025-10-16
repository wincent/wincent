/**
 * SPDX-FileCopyrightText: Copyright 2013-present Greg Hurrell and contributors.
 * SPDX-License-Identifier: MIT
 */

import {stderr} from 'node:process';

import stringify from './stringify.mts';

/**
 * https://en.wikipedia.org/wiki/ANSI_escape_code#Colors
 * https://stackoverflow.com/a/41407246/2103996
 */
export const BOLD = '\x1b[1m';
export const GREEN = '\x1b[32m';
export const PURPLE = '\x1b[35m';
export const RED = '\x1b[31m';
export const RESET = '\x1b[0m';
// export const REVERSE = '\x1b[7m'; // not sure if we'll need this yet
export const YELLOW = '\x1b[33m';

/**
 * Syslog levels:
 *
 * - 0, emergency (not implemented): "system is unusable"
 * - 1, alert (not implemented): "action must be taken immediately"
 * - 2, critical (not implemented): "hard device errors"
 * - 3, error: "error conditions"
 * - 4, warning: "warning conditions"
 * - 5, notice: "normal but significant conditions"
 * - 6, info: "informational messages"
 * - 7, debug: "debug-level messages"
 *
 * @see https://en.wikipedia.org/wiki/Syslog
 */
export const EMERGENCY = 0;
export const ALERT = 1;
export const CRITICAL = 2;
export const ERROR = 3;
export const WARNING = 4;
export const NOTICE = 5;
export const INFO = 6;
export const DEBUG = 7;

type LogLevel =
  | typeof EMERGENCY
  | typeof ALERT
  | typeof CRITICAL
  | typeof ERROR
  | typeof WARNING
  | typeof NOTICE
  | typeof INFO
  | typeof DEBUG;

let logLevel: LogLevel = INFO;

export function debug(...args: Array<any>) {
  if (logLevel >= DEBUG) {
    printLine(`${BOLD}${PURPLE}[debug] `, ...args, `${RESET}`);
  }
}

export function error(...args: Array<any>) {
  if (logLevel >= ERROR) {
    printLine(`${BOLD}${RED}[error] `, ...args, `${RESET}`);
  }
}

export function getLogLevel(): LogLevel {
  return logLevel;
}

export function info(...args: Array<any>) {
  printLine(...args);
}

export function notice(...args: Array<any>) {
  if (logLevel >= NOTICE) {
    printLine(`${BOLD}${GREEN}`, ...args, `${RESET}`);
  }
}

export function print(...args: Array<any>) {
  stderr.write(
    args
      .map((arg) => {
        if (typeof arg === 'string') {
          return arg;
        } else {
          return stringify(arg);
        }
      })
      .join(''),
  );
}

export function printLine(...args: Array<any>) {
  print(...args, '\n');
}

export function setLogLevel(level: LogLevel) {
  logLevel = level;
  if (logLevel === DEBUG) {
    debug(`set log level to ${logLevel}`);
  }
}

export function warn(...args: Array<any>) {
  if (logLevel >= WARNING) {
    printLine(`${BOLD}${YELLOW}[warning] `, ...args, `${RESET}`);
  }
}
