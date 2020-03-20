import {clearLine, cursorTo} from 'readline';

export {default as COLORS} from './console/colors';

export function clear() {
  return new Promise(resolve => {
    clearLine(process.stderr, 0, () => {
      cursorTo(process.stderr, 0, undefined, resolve);
    });
  });
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

log.clear = clear;
print.clear = clear;
