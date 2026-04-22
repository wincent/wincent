/**
 * Notify Extension
 *
 * Sends a desktop notification when pi finishes and is waiting for input.
 * Delegates to the `notify` shell dispatcher (see ~/.zsh/bin/notify), which
 * picks an appropriate backend (clip-notify, terminal-notifier, or
 * notify-send) based on the current environment.
 *
 * Based on: https://github.com/badlogic/pi-mono/blob/main/packages/coding-agent/examples/extensions/notify.ts
 */

import type {ExtensionAPI} from '@mariozechner/pi-coding-agent';
import {execFile} from 'node:child_process';

function notify(title: string, body: string): void {
  const child = execFile('notify', ['--title', title, '--message', body]);
  // Swallow spawn errors (eg. `notify` not on $PATH) so a missing dispatcher
  // can never crash pi with an unhandled 'error' event.
  child.on('error', () => {});
}

export default function (pi: ExtensionAPI) {
  pi.on('agent_end', async () => {
    notify('pi', 'Ready for input');
  });
}
