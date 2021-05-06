import {clearLine, cursorTo} from 'readline';

import stringify from './stringify.js';
import COLORS from './console/COLORS.js';

export {COLORS};

type ValueOf<T> = T[keyof T];

export type LogLevel = ValueOf<typeof LOG_LEVEL>;

const {bold, green, purple, red, yellow} = COLORS;

let logLevel: LogLevel = 6;

const PREFIXES = ['debug', 'error', 'info', 'notice', 'warning'];

const PREFIX_LENGTH = PREFIXES.reduce((acc, prefix) => {
  return Math.max(`[${prefix}] `.length, acc);
}, 0);

const PREFIX_MAP = Object.fromEntries(
  PREFIXES.map((prefix) => {
    return [prefix, `[${prefix}] `.padEnd(PREFIX_LENGTH)];
  })
);

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
export const LOG_LEVEL = {
  EMERGENCY: 0,
  ALERT: 1,
  CRITICAL: 2,
  ERROR: 3,
  WARNING: 4,
  NOTICE: 5,
  INFO: 6,
  DEBUG: 7,
} as const;

export function clear() {
  return new Promise((resolve) => {
    clearLine(process.stderr, 0, () => {
      cursorTo(process.stderr, 0, undefined, resolve);
    });
  });
}

/**
 * Executes `callback()` only when debugging.
 *
 * Useful for occasions when you want to avoid the expense of evaluating the
 * arguments to `log.debug()`.
 */
export async function debug(callback: () => unknown): Promise<void> {
  if (logLevel >= LOG_LEVEL.DEBUG) {
    await callback();
  }
}

export function getLogLevel(): LogLevel {
  return logLevel;
}

export function log(...args: Array<any>) {
  print(...args);
  print('\n');
}

log.debug = function debug(message: string) {
  if (logLevel >= LOG_LEVEL.DEBUG) {
    log(purple.bold`${PREFIX_MAP.debug}` + message);
  }
};

log.error = function error(message: string) {
  if (logLevel >= LOG_LEVEL.ERROR) {
    log(red.bold`${PREFIX_MAP.error}` + message);
  }
};

log.info = function info(message: string) {
  if (logLevel >= LOG_LEVEL.INFO) {
    log(bold`${PREFIX_MAP.info}` + message);
  }
};

log.notice = function notice(message: string) {
  if (logLevel >= LOG_LEVEL.NOTICE) {
    log(green.bold`${PREFIX_MAP.notice}` + message);
  }
};

log.warn = function warn(message: string) {
  if (logLevel >= LOG_LEVEL.WARNING) {
    log(yellow.bold`${PREFIX_MAP.warning}` + message);
  }
};

export function print(...args: Array<any>) {
  process.stderr.write(
    args
      .map((arg) => {
        if (typeof arg === 'string') {
          return arg;
        } else {
          return stringify(arg);
        }
      })
      .join(' ')
  );
}

export function setLogLevel(level: LogLevel) {
  logLevel = level;
}

log.clear = clear;

print.clear = clear;
