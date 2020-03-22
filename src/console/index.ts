import {clearLine, cursorTo} from 'readline';

import COLORS from './colors';

export {COLORS};

const {bold, purple, red, yellow} = COLORS;

export function clear() {
  return new Promise(resolve => {
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

export function print(...args: Array<any>) {
  process.stderr.write(
    args
      .map(arg => {
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
      .join(' '),
  );
}

function warn(message: string) {
  log(yellow.bold`[warning]` + ` ${message}`);
}

log.clear = clear;
log.debug = debug;
log.error = error;
log.info = info;
log.warn = warn;

print.clear = clear;
