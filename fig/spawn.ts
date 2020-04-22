import ErrorWithMetadata from './ErrorWithMetadata.js';
import * as child_process from './child_process.js';

import type {SpawnOptions} from 'child_process';

// TODO: delete this, probably; currently unused...

/**
 * Fire-and-forget child process execution.
 *
 * Doesn't return stderr or stdout; resolves on success and rejects on failure.
 */
export default async function spawn(
    command: string,
    args: Array<string>,
    options: SpawnOptions = {}
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

        const child = child_process.spawn(command, args, {
            ...options,
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
