import * as child_process from 'child_process';
import {randomBytes} from 'crypto';

type Options = {
  passphrase: string;
};

type Result = {
  error: Error | null;
  signal: string | null;
  status: number | null;
  stderr: string;
  stdout: string;
};

export default async function sudo(
  command: string,
  args: Array<string>,
  options: Options
): Promise<Result> {
  return new Promise((resolve, reject) => {
    const result = {
      error: null,
      signal: null,
      status: null,
      stderr: '',
      stdout: '',
    };

    const PROMPT_TEXT = `sudo[${randomBytes(16).toString('hex')}]:`;

    const child = child_process.spawn('sudo', [
      '-S',
      '-k',
      '-p',
      PROMPT_TEXT,
      '--',
      command,
      ...args,
    ]);

    // Sadly, we'll still see "Sorry, try again" if the wrong password is
    // supplied, because sudo is logging it directly to /dev/tty, not to stderr.
    //
    // See: https://github.com/sudo-project/sudo/blob/972670bf/plugins/sudoers/sudo_printf.c#L47
    child.stderr.on('data', (data) => {
      if (data.toString() === PROMPT_TEXT) {
        child.stdin.write(`${options.passphrase}\n`);

        // No point in retrying; by calling `end()` here we'll get one shot.
        child.stdin.end();
      } else {
        result.stderr += data.toString();
      }
    });

    child.stdout.on('data', (data) => {
      result.stdout += data.toString();
    });

    child.on('error', (error) =>
      reject({
        ...result,
        error,
      })
    );

    child.on('exit', (status, signal) => {
      if (typeof status === 'number') {
        resolve({
          ...result,
          status,
        });
      } else if (signal) {
        resolve({
          ...result,
          status,
        });
      }
    });
  });
}
