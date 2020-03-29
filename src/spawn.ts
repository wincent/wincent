import {spawnSync} from 'child_process';

import {log} from './console';

export default function spawn(command: string, ...args: Array<string>) {
  const {error, signal, status, stderr, stdout} = spawnSync(command, args, {
    stdio: ['inherit', 'pipe', 'inherit'],
  });

  if (!error) {
  } else {
    const description = [command, ...args].join(' ');

    if (error) {
      log.error(`command ${description} encountered error: ${error}`);
    } else if (signal) {
      log.error(`command ${description} exited due to signal ${signal}`);
    } else if (status) {
      log.error(`command ${description} exited with status ${status}`);
    }

    log.debug(`\nstdout:\n\n${stdout}`);
    log.debug(`\nstderr:\n\n${stderr}`);

    // Want a subclass here so I can extract message
    throw new Error('temporary error until I make a subclass');
  }
}
