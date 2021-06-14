import * as readline from 'readline';
import {Writable} from 'stream';

import COLORS from './console/COLORS.js';
import {log} from './console.js';

type Options = {
  private?: boolean;
};

async function prompt(text: string, options: Options = {}): Promise<string> {
  if (process.env.NON_INTERACTIVE) {
    throw new Error('prompt(): called, but NON_INTERACTIVE is set');
  }

  let muted = false;

  // https://stackoverflow.com/a/33500118/2103996
  const stdout = new Writable({
    write: (chunk, _encoding, callback) => {
      if (!muted) {
        process.stdout.write(chunk);
      }
      callback();
    },
  });

  const rl = readline.createInterface({
    historySize: 0,
    input: process.stdin,
    output: stdout,
    terminal: true,
  });

  try {
    const response = new Promise<string>((resolve) => {
      rl.question(COLORS.yellow(text), (response) => {
        process.stdout.write('\n');
        resolve(response);
      });
    });

    muted = !!options.private;

    return await response;
  } finally {
    rl.close();
  }
}

prompt.confirm = async (text: string): Promise<boolean> => {
  if (process.env.NON_INTERACTIVE) {
    log.info(`${text}? [y/n]: (assuming "y" because NON_INTERACTIVE is set)`);
    return true;
  }

  const reply = (await prompt(`${text}? [y/n]: `)).toLowerCase().trim();

  return 'yes'.startsWith(reply);
};

export default prompt;
