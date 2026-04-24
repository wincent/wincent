import {log} from './console.ts';

// TODO: ansible also has: unreachable, rescued, ignored
// decide whether we need any of those.

export async function changed(message: string): Promise<void> {
  await log.notice(`Changed: ${message}`);
}

export async function failed(message: string): Promise<void> {
  await log.error(`Failed: ${message}`);
}

export async function ok(message: string): Promise<void> {
  await log.info(`Ok: ${message}`);
}

export async function skipped(message: string): Promise<void> {
  await log.info(`Skipped: ${message}`);
}
