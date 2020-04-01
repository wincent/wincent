import {clearLine, cursorTo} from 'readline';

import COLORS from './colors';

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

function debug(message: string) {
  if (logLevel >= LOG_LEVEL.DEBUG) {
    log(purple.bold`${PREFIX_MAP.debug}` + message);
  }
}

function error(message: string) {
  if (logLevel >= LOG_LEVEL.ERROR) {
    log(red.bold`${PREFIX_MAP.error}` + message);
  }
}

function info(message: string) {
  if (logLevel >= LOG_LEVEL.INFO) {
    log(bold`${PREFIX_MAP.info}` + message);
  }
}

export function log(...args: Array<any>) {
  print(...args);
  print('\n');
}

function notice(message: string) {
  if (logLevel >= LOG_LEVEL.NOTICE) {
    log(green.bold`${PREFIX_MAP.notice}` + message);
  }
}

export function print(...args: Array<any>) {
  process.stderr.write(
    args
      .map((arg) => {
        try {
          if (typeof arg === 'object' && arg) {
            return JSON.stringify(arg, null, 2);
          } else {
            return String(arg);
          }
        } catch {
          return '???';
        }
      })
      .join(' ')
  );
}

export function getLogLevel(): LogLevel {
  return logLevel;
}

export function setLogLevel(level: LogLevel) {
  logLevel = level;
}

function warn(message: string) {
  if (logLevel >= LOG_LEVEL.WARNING) {
    log(yellow.bold`${PREFIX_MAP.warning}` + message);
  }
}

log.clear = clear;
log.debug = debug;
log.error = error;
log.info = info;
log.notice = notice;
log.warn = warn;

print.clear = clear;
