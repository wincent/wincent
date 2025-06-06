import * as process from 'node:process';
import * as readline from 'node:readline';
import {Writable} from 'node:stream';

import assert from './assert.ts';
import {log} from './console.ts';
import COLORS from './console/COLORS.ts';
import lock from './lock.ts';

type Options = {
  private?: boolean;
};

// TODO: consider making a mutex that will ensure only one thing actually
// prompts at a time (or that nothing else prints while prompting)
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
    let result;

    await lock('console', async () => {
      const response = new Promise<string>((resolve) => {
        rl.question(COLORS.yellow(text), (response) => {
          process.stdout.write('\n');
          resolve(response);
        });
      });

      muted = !!options.private;

      result = await response;
    });

    assert(typeof result === 'string');
    return result;
  } finally {
    rl.close();
  }
}

prompt.confirm = async (text: string): Promise<boolean> => {
  if (process.env.NON_INTERACTIVE) {
    await log.info(
      `${text}? [y/n]: (assuming "y" because NON_INTERACTIVE is set)`,
    );
    return true;
  }

  const reply = (await prompt(`${text}? [y/n]: `)).toLowerCase().trim();

  return 'yes'.startsWith(reply);
};

export default prompt;
