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

export function clear() {
  return new Promise((resolve) => {
    clearLine(process.stderr, 0, () => {
      cursorTo(process.stderr, 0, undefined, resolve);
    });
  });
}

function debug(message: string) {
  log(purple.bold`[debug]` + ` ${message}`);
}

function error(message: string) {
  log(red.bold`[error]` + ` ${message}`);
}

function info(message: string) {
  log(bold`[info]` + ` ${message}`);
}

export function log(...args: Array<any>) {
  print(...args);
  print('\n');
}

function notice(message: string) {
  log(green.bold`[notice]` + ` ${message}`);
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
  log(yellow.bold`[warning]` + ` ${message}`);
}

log.clear = clear;
log.debug = debug;
log.error = error;
log.info = info;
log.notice = notice;
log.warn = warn;

print.clear = clear;
