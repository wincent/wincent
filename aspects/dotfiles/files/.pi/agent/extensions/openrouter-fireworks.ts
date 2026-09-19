// Pi extension: DeepSeek V4.1 Flash via OpenRouter, pinned to Fireworks.
//
// Requires: OPENROUTER_API_KEY.
//
// See: https://openrouter.ai/deepseek/deepseek-v4.1-flash

import type {ExtensionAPI} from '@earendil-works/pi-coding-agent';

export default function (pi: ExtensionAPI) {
  pi.registerProvider('openrouter-fireworks', {
    name: 'OpenRouter (Fireworks)',
    baseUrl: 'https://openrouter.ai/api/v1',
    apiKey: 'OPENROUTER_API_KEY',
    api: 'openai-completions',
    models: [{
      id: 'deepseek/deepseek-v4.1-flash',
      name: 'DeepSeek V4.1 Flash (Fireworks, ZDR)',
      reasoning: true,
      thinkingLevelMap: {
        off: null,
        minimal: 'low',
        low: 'low',
        medium: 'high',
        high: 'high',
        xhigh: 'max',
        max: 'max',
      },
      input: ['text'],
      contextWindow: 1048576,
      maxTokens: 131072,
      cost: {input: 0.22, output: 0.66, cacheRead: 0.007, cacheWrite: 0},
      compat: {
        thinkingFormat: 'openrouter',
        sendSessionAffinityHeaders: true,
        sessionAffinityFormat: 'openrouter',
        openRouterRouting: {
          only: ['fireworks'],
          allow_fallbacks: false,
          data_collection: 'deny',
          zdr: true,
        },
      },
    }],
  });
}
