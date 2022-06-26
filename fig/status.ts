import {log} from './console.js';

// TODO: ansible also has: unreachable, rescued, ignored
// decide whether we need any of those.

export async function changed(message: string) {
  await log.notice(`Changed: ${message}`);
}

export async function failed(message: string) {
  await log.error(`Failed: ${message}`);
}

export async function ok(message: string) {
  await log.info(`Ok: ${message}`);
}

export async function skipped(message: string) {
  await log.info(`Skipped: ${message}`);
}
