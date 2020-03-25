import {spawn} from 'child_process';

export default async function capture(command: string, ...args: Array<string>) {
  return new Promise((resolve, reject) => {
    const child = spawn(command, args, {
      stdio: ['inherit', 'pipe', 'inherit'],
    });

    let stdout = '';

    child.stdout.on('data', (data) => (stdout += data.toString()));

    child.on('close', (code, signal) => {
      if (code) {
        reject(
          new Error(
            `Exit code ${code} returned from: ${[command, ...args].join(' ')}`
          )
        );
      } else if (signal) {
        reject(
          new Error(
            `Signal ${signal} received by: ${[command, ...args].join(' ')}`
          )
        );
      } else {
        resolve(stdout.trimEnd());
      }
    });
  });
}
