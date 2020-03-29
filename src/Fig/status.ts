import {log} from '../console';

// TODO: ansible also has: unreachable, rescued, ignored
// decide whether we need any of those.

export function changed(message: string) {
  log.notice(`changed: ${message}`);
}

export function failed(message: string) {
  log.error(`failed: ${message}`);
}

export function ok(message: string) {
  log.info(`ok: ${message}`);
}

export function skipped(message: string) {
  log.info(`skipped: ${message}`);
}
