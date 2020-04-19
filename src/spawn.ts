import * as child_process from 'child_process';

import ErrorWithMetadata from './ErrorWithMetadata.js';

/**
 * Fire-and-forget child process execution.
 *
 * Doesn't return stderr or stdout; resolves on success and rejects on failure.
 */
export default async function spawn(
    command: string,
    ...args: Array<string>
): Promise<void> {
    return new Promise((resolve, reject) => {
        let stderr = '';
        let stdout = '';

        function fail(message: string) {
            const description = [command, ...args].join(' ');
            const metadata = {stderr, stdout};

            reject(
                new ErrorWithMetadata(
                    `command ${description} ${message}`,
                    metadata
                )
            );
        }

        // `toString()` here in case we have a Path string-like.
        const child = child_process.spawn(command.toString(), args, {
            stdio: ['inherit', 'pipe', 'pipe'],
        });

        child.stderr.on('data', (data) => (stderr += data.toString()));
        child.stdout.on('data', (data) => (stdout += data.toString()));

        child.on('error', (error) => {
            fail(`encountered error: ${error}`);
        });

        child.on('exit', (code, signal) => {
            if (code) {
                fail(`exited with status ${code}`);
            } else if (signal) {
                fail(`exited due to signal ${signal}`);
            } else {
                resolve();
            }
        });
    });
}
