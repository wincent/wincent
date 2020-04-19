import {randomBytes} from 'crypto';

import {spawn} from './child_process.js';

type Options = {
    passphrase?: string;
};

type Result = {
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

        const result = {
            command: final.join(' '),
            error: null,
            signal: null,
            status: null,
            stderr: '',
            stdout: '',
        };

        const child = spawn(final[0], final.slice(1));

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

        child.stdout.on('data', (data) => {
            result.stdout += data.toString();
        });

        child.on('error', (error) =>
            resolve({
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
                    signal,
                });
            }
        });
    });
}
