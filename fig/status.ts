import {log} from './console.js';

// TODO: ansible also has: unreachable, rescued, ignored
// decide whether we need any of those.

export function changed(message: string) {
    log.notice(`Changed: ${message}`);
}

export function failed(message: string) {
    log.error(`Failed: ${message}`);
}

export function ok(message: string) {
    log.info(`Ok: ${message}`);
}

export function skipped(message: string) {
    log.info(`Skipped: ${message}`);
}
