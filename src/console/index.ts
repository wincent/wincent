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

import {clearLine, cursorTo} from 'readline';

import COLORS from './colors';

export {COLORS};

const {bold, green, purple, red, yellow} = COLORS;

const PREFIXES = ['debug', 'error', 'info', 'notice', 'warning'];

const PREFIX_LENGTH = PREFIXES.reduce((acc, prefix) => {
  return Math.max(`[${prefix}] `.length, acc);
}, 0);

const PREFIX_MAP = Object.fromEntries(
  PREFIXES.map((prefix) => {
    return [prefix, `[${prefix}] `.padEnd(PREFIX_LENGTH)];
  })
);

export function clear() {
  return new Promise((resolve) => {
    clearLine(process.stderr, 0, () => {
      cursorTo(process.stderr, 0, undefined, resolve);
    });
  });
}

function debug(message: string) {
  log(purple.bold`${PREFIX_MAP.debug}` + message);
}

function error(message: string) {
  log(red.bold`${PREFIX_MAP.error}` + message);
}

function info(message: string) {
  log(bold`${PREFIX_MAP.info}` + message);
}

export function log(...args: Array<any>) {
  print(...args);
  print('\n');
}

function notice(message: string) {
  log(green.bold`${PREFIX_MAP.notice}` + message);
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

function warn(message: string) {
  log(yellow.bold`${PREFIX_MAP.warning}` + message);
}

log.clear = clear;
log.debug = debug;
log.error = error;
log.info = info;
log.notice = notice;
log.warn = warn;

print.clear = clear;
