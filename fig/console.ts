import * as process from 'node:process';
import {clearLine, cursorTo} from 'node:readline';

import COLORS from './console/COLORS.ts';
import lock from './lock.ts';
import stringify from './stringify.ts';

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
  }),
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
  return lock('console', async () => {
    return new Promise<void>((resolve) => {
      clearLine(process.stderr, 0, () => {
        cursorTo(process.stderr, 0, undefined, resolve);
      });
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

export async function log(...args: Array<unknown>) {
  await print(...args, '\n');
}

log.debug = async function debug(message: string) {
  if (logLevel >= LOG_LEVEL.DEBUG) {
    await log(purple.bold`${PREFIX_MAP.debug}` + message);
  }
};

log.error = async function error(message: string) {
  if (logLevel >= LOG_LEVEL.ERROR) {
    await log(red.bold`${PREFIX_MAP.error}` + message);
  }
};

log.info = async function info(message: string) {
  if (logLevel >= LOG_LEVEL.INFO) {
    await log(bold`${PREFIX_MAP.info}` + message);
  }
};

log.notice = async function notice(message: string) {
  if (logLevel >= LOG_LEVEL.NOTICE) {
    await log(green.bold`${PREFIX_MAP.notice}` + message);
  }
};

log.warn = async function warn(message: string) {
  if (logLevel >= LOG_LEVEL.WARNING) {
    await log(yellow.bold`${PREFIX_MAP.warning}` + message);
  }
};

export async function print(...args: Array<unknown>) {
  await lock('console', async () => {
    process.stderr.write(
      args
        .map((arg) => {
          if (typeof arg === 'string') {
            return arg;
          } else {
            return stringify(arg);
          }
        })
        .join(' '),
    );
  });
}

export function nextLogLevel(level: LogLevel): LogLevel {
  const nextLevel = level + 1;
  if (isLogLevel(nextLevel)) {
    return nextLevel;
  } else {
    return LOG_LEVEL.DEBUG;
  }
}

function isLogLevel(level: number): level is LogLevel {
  const values = Object.values(LOG_LEVEL);
  return (
    level >= Math.min(...values) &&
    level <= Math.max(...values) &&
    Math.round(level) === level
  );
}

export function setLogLevel(level: LogLevel) {
  logLevel = level;
}

log.clear = clear;

print.clear = clear;
