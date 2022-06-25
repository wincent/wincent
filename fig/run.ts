import {randomBytes} from 'crypto';

import {spawn} from './child_process.js';

type Options = {
  chdir?: string;
  env?: NodeJS.ProcessEnv;
  passphrase?: string;
};

export type Result = {
  command: string;
  error: Error | null;
  signal: string | null;
  status: number | null;
  stderr: string;
  stdout: string;
};

/**
 * Run a command and return the result, escalating with `sudo` if a `passhprase`
 * is supplied via the `options` parameter.
 */
export default async function run(
  command: string,
  args: Array<string>,
  options: Options = {}
): Promise<Result> {
  return new Promise((resolve) => {
    const prompt = `sudo[${randomBytes(16).toString('hex')}]:`;

    const final =
      options.passphrase !== undefined
        ? ['sudo', '-S', '-k', '-p', prompt, '--', command, ...args]
        : [command, ...args];

    const result: Result = {
      command: final.join(' '),
      error: null,
      signal: null,
      status: null,
      stderr: '',
      stdout: '',
    };

    const child = spawn(final[0].toString(), final.slice(1).map(String), {
      cwd: options.chdir ? options.chdir.toString() : undefined,
      env: options.env,
    });

    // Sadly, we may see "Sorry, try again" if the wrong password is
    // supplied, because sudo may be configured to log it directly to
    // /dev/tty, not to stderr (true on macOS, not on Amazon Linux).
    //
    // See: https://github.com/sudo-project/sudo/blob/972670bf/plugins/sudoers/sudo_printf.c#L47
    child.stderr.on('data', (data) => {
      if (data.toString() === prompt) {
        child.stdin.write(`${options.passphrase}\n`);

        // No point in retrying; by calling `end()` here we'll get one shot.
        child.stdin.end();
      } else {
        result.stderr += data.toString();
      }
    });

    // "The 'close' event is emitted after a process has ended and the stdio
    // streams of a child process have been closed. This is distinct from
    // the 'exit' event, since multiple processes might share the same stdio
    // streams. The 'close' event will always emit after 'exit' was already
    // emitted, or 'error' if the child failed to spawn."
    //
    // See: https://nodejs.org/api/child_process.html#event-close
    child.stdout.on('close', () => {
      resolve(result);
    });

    child.stdout.on('data', (data) => {
      result.stdout += data.toString();
    });

    // "The 'exit' event may or may not fire after an error has occurred. When
    // listening to both the 'exit' and 'error' events, guard against
    // accidentally invoking handler functions multiple times."
    //
    // See: https://nodejs.org/api/child_process.html#event-close
    child.on('error', (error) => {
      result.error = error;
    });

    // "The 'exit' event is emitted after the child process ends. If the process
    // exited, code is the final exit code of the process, otherwise null. If
    // the process terminated due to receipt of a signal, signal is the string
    // name of the signal, otherwise null. One of the two will always be
    // non-null.
    //
    // When the 'exit' event is triggered, child process stdio streams might
    // still be open."
    //
    // See: https://nodejs.org/api/child_process.html#event-exit
    child.on('exit', (status, signal) => {
      if (typeof status === 'number') {
        result.status = status;
      } else if (signal) {
        result.signal = signal;
      }
    });
  });
}
