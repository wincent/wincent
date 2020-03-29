import {spawnSync} from 'child_process';

import ErrorWithMetadata from './ErrorWithMetadata';

export default function spawn(command: string, ...args: Array<string>) {
  const {error, signal, status, stderr, stdout} = spawnSync(command, args, {
    stdio: ['inherit', 'pipe', 'pipe'],
  });

  if (error || signal || status) {
    const description = [command, ...args].join(' ');

    let message;

    if (error) {
      message = `command ${description} encountered error: ${error}`;
    } else if (signal) {
      message = `command ${description} exited due to signal ${signal}`;
    } else if (status) {
      message = `command ${description} exited with status ${status}`;
    } else {
      // Will never get here, but need an "else" to keep TypeScript happy.
      message = `command ${description} failed`;
    }

    const metadata = {
      stderr: stderr.toString(),
      stdout: stderr.toString(),
    };

    throw new ErrorWithMetadata(message, metadata);
  }
}
