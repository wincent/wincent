/**
 * Model Info Extension
 *
 * Injects a small block into the system prompt on every turn that names
 * the active model (provider + id + display name) and the active thinking
 * level. Without this, the agent has no reliable way to identify itself
 * at runtime.
 *
 * Use case: skills that need accurate self-attribution. The `git-commit`
 * and `jj-commit` skills derive their `Co-Authored-By` trailer from the
 * model identity; without this extension they fall back to a generic
 * `AI Assistant <noreply@example.com>` line.
 *
 * The block is regenerated on every turn (`before_agent_start` runs once
 * per user prompt), so `/model` swaps and thinking-level changes via
 * `/thinking` are reflected live without restart.
 */

import type {ExtensionAPI} from '@mariozechner/pi-coding-agent';

export default function (pi: ExtensionAPI) {
  pi.on('before_agent_start', async (event, ctx) => {
    const model = ctx.model;
    const thinking = pi.getThinkingLevel();

    const lines = ['## Pi runtime', ''];
    if (model) {
      lines.push(
        `- Active model: \`${model.provider}/${model.id}\` (${model.name})`,
      );
    } else {
      lines.push('- Active model: unknown');
    }
    lines.push(`- Active thinking level: \`${thinking}\``);

    return {
      systemPrompt: event.systemPrompt + '\n\n' + lines.join('\n') + '\n',
    };
  });
}
