// Pi extension: OpenRouter models pinned to a ZDR upstream.
//
// Requires: OPENROUTER_API_KEY.
//
// Each upstream pin has its own provider id, leaving pi's built-in OpenRouter
// catalog untouched. Both models use the real OpenRouter slug, so ordinary
// requests and summaries work without an agent-loop request rewrite hook.
//
// See: https://openrouter.ai/deepseek/deepseek-v4.1-flash

import type {
  ExtensionAPI,
  ProviderModelConfig,
} from '@earendil-works/pi-coding-agent';

const UPSTREAM_ID = 'deepseek/deepseek-v4.1-flash';

// Pi 0.99 adds image and classifier variants. Narrow to chat before Omit;
// reasoning also exists in the pre-0.99 model type, unlike the new type tag.
type ChatModelConfig = Extract<ProviderModelConfig, {reasoning: boolean}>;

const deepseekV41Flash: Omit<ChatModelConfig, 'cost' | 'id'> = {
  name: 'DeepSeek V4.1 Flash',
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
  compat: {
    thinkingFormat: 'openrouter',
    sendSessionAffinityHeaders: true,
    sessionAffinityFormat: 'openrouter',
  },
};

export default function (pi: ExtensionAPI) {
  pi.registerProvider('openrouter-zdr-fireworks', {
    name: 'OpenRouter (Fireworks, ZDR)',
    baseUrl: 'https://openrouter.ai/api/v1',
    apiKey: '$OPENROUTER_API_KEY',
    api: 'openai-completions',
    models: [{
      ...deepseekV41Flash,
      id: UPSTREAM_ID,
      name: 'DeepSeek V4.1 Flash (Fireworks, ZDR)',
      // USD per million tokens: https://fireworks.ai/models/deepseek-ai/deepseek-v4p1-flash
      cost: {input: 0.22, output: 0.66, cacheRead: 0.007, cacheWrite: 0},
      compat: {
        ...deepseekV41Flash.compat,
        openRouterRouting: {
          only: ['fireworks'],
          allow_fallbacks: false,
          data_collection: 'deny',
          zdr: true,
        },
      },
    }],
  });

  pi.registerProvider('openrouter-zdr-deepinfra', {
    name: 'OpenRouter (DeepInfra, ZDR)',
    baseUrl: 'https://openrouter.ai/api/v1',
    apiKey: '$OPENROUTER_API_KEY',
    api: 'openai-completions',
    models: [{
      ...deepseekV41Flash,
      id: UPSTREAM_ID,
      name: 'DeepSeek V4.1 Flash (DeepInfra, ZDR)',
      // USD per million tokens: https://deepinfra.com/deepseek-ai/DeepSeek-V4.1-Flash
      cost: {input: 0.14, output: 0.42, cacheRead: 0.0042, cacheWrite: 0},
      compat: {
        ...deepseekV41Flash.compat,
        openRouterRouting: {
          only: ['deepinfra'],
          allow_fallbacks: false,
          data_collection: 'deny',
          zdr: true,
        },
      },
    }],
  });
}
