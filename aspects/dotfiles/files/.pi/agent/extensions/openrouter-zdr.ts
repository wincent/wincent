// Pi extension: OpenRouter models pinned to a ZDR upstream.
//
// Requires: OPENROUTER_API_KEY.
//
// Provider id is `openrouter-zdr`, not `openrouter`, so this does not replace
// pi's built-in OpenRouter catalog. Pi keys models by id and sends that id as
// the OpenRouter slug, so each pin uses its own id. The request hook rewrites
// those ids back to the shared upstream slug.
//
// See: https://openrouter.ai/deepseek/deepseek-v4.1-flash

import type {
  ExtensionAPI,
  ProviderModelConfig,
} from '@earendil-works/pi-coding-agent';

const PROVIDER_ID = 'openrouter-zdr';
const UPSTREAM_ID = 'deepseek/deepseek-v4.1-flash';

const deepseekV41Flash: Omit<ProviderModelConfig, 'cost' | 'id'> = {
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
  pi.registerProvider(PROVIDER_ID, {
    name: 'OpenRouter (ZDR)',
    baseUrl: 'https://openrouter.ai/api/v1',
    apiKey: 'OPENROUTER_API_KEY',
    api: 'openai-completions',
    models: [{
      ...deepseekV41Flash,
      id: `${UPSTREAM_ID}-fireworks`,
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
    }, {
      ...deepseekV41Flash,
      id: `${UPSTREAM_ID}-deepinfra`,
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

  // Pi would otherwise send each pin's id as the OpenRouter slug.
  pi.on('before_provider_request', (event, ctx) => {
    const model = ctx.model;
    if (!model || model.provider !== PROVIDER_ID) {
      return;
    }
    if (!model.id.startsWith(`${UPSTREAM_ID}-`)) {
      return;
    }
    if (typeof event.payload !== 'object' || event.payload === null) {
      return;
    }
    if (!('model' in event.payload) || event.payload.model !== model.id) {
      return;
    }
    return {...event.payload, model: UPSTREAM_ID};
  });
}
