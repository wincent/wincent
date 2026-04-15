/**
 * Jujutsu Guard Extension
 *
 * Blocks raw `git add` and `git commit` commands when running inside a
 * Jujutsu repository. These operations should go through `jj` instead.
 */

import type {ExtensionAPI} from '@mariozechner/pi-coding-agent';
import {isToolCallEventType} from '@mariozechner/pi-coding-agent';
import {existsSync} from 'node:fs';
import {join} from 'node:path';

// Not a security boundary — just a heuristic to catch the most common
// forms of `git add` and `git commit` that an LLM agent is likely to
// produce. Won't catch every possible invocation (eg. `env A=1 git
// commit`) but covers the reasonable cases.
const BLOCKED_PATTERNS = [
  /(?:^|[;&|]\s*)git\b.+\badd\b/,
  /(?:^|[;&|]\s*)git\b.+\bcommit\b/,
];

async function isJujutsuRepo(pi: ExtensionAPI): Promise<boolean> {
  const {stdout, code} = await pi.exec('git', ['rev-parse', '--show-toplevel']);
  if (code !== 0) { return false; }
  return existsSync(join(stdout.trim(), '.jj'));
}

export default function (pi: ExtensionAPI) {
  pi.on('tool_call', async (event) => {
    if (!isToolCallEventType('bash', event)) { return; }

    const command = event.input.command;
    if (!BLOCKED_PATTERNS.some((p) => p.test(command))) { return; }

    if (!(await isJujutsuRepo(pi))) { return; }

    return {
      block: true,
      reason:
        'This is a Jujutsu repository. Use `jj` commands instead of raw git add/commit.',
    };
  });
}
