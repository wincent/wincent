/**
 * Notify Extension
 *
 * Sends a desktop notification when pi finishes and is waiting for input.
 * Uses terminal-notifier, clicking the notification activates kitty.
 *
 * Based on: https://github.com/badlogic/pi-mono/blob/main/packages/coding-agent/examples/extensions/notify.ts
 */

import type {ExtensionAPI} from '@mariozechner/pi-coding-agent';
import {execFile} from 'node:child_process';

function notify(title: string, body: string): void {
  execFile('terminal-notifier', [
    '-title',
    title,
    '-message',
    body,
    '-activate',
    'net.kovidgoyal.kitty',
  ]);
}

export default function (pi: ExtensionAPI) {
  pi.on('agent_end', async () => {
    notify('pi', 'Ready for input');
  });
}
