import {readFile} from 'node:fs/promises';

export type ProxyConfig = {
  credentials: Record<string, JSONObject>;
  capture: Record<string, JSONObject>;
};

function isObject(value: unknown): value is Record<string, unknown> {
  return typeof value === 'object' && value !== null && !Array.isArray(value);
}

/** Optional private proxy configuration. No commands or credential lookups. */
export async function readProxyConfig(
  env: NodeJS.ProcessEnv = process.env,
): Promise<ProxyConfig> {
  const empty = {credentials: {}, capture: {}};
  const path = env.NONO_PROXY_CONFIG;
  if (!path) {
    return empty;
  }

  let text: string;
  try {
    text = await readFile(path, 'utf8');
  } catch (error) {
    if ((error as NodeJS.ErrnoException).code === 'ENOENT') {
      return empty;
    }
    throw error;
  }

  // Replace only whole-string $NAME references, after parsing JSON. Values
  // remain data: never evaluate shell expressions or expand object keys.
  function expand(value: unknown): unknown {
    if (typeof value === 'string') {
      const name = /^\$([A-Za-z_][A-Za-z0-9_]*)$/.exec(value)?.[1];
      if (name) {
        const replacement = env[name];
        if (!replacement) {
          throw new Error(
            `NONO_PROXY_CONFIG requires environment variable ${name}.`,
          );
        }
        return replacement;
      }
    } else if (Array.isArray(value)) {
      return value.map(expand);
    } else if (isObject(value)) {
      return Object.fromEntries(
        Object.entries(value).map(([key, entry]) => [key, expand(entry)]),
      );
    }
    return value;
  }

  let parsed: unknown;
  try {
    parsed = JSON.parse(text);
  } catch {
    // Do not print the source text: local configuration may be private.
    throw new Error('NONO_PROXY_CONFIG must contain valid JSON.');
  }
  if (
    !isObject(parsed) ||
    Object.keys(parsed).some((key) =>
      key !== 'credentials' && key !== 'capture'
    )
  ) {
    throw new Error(
      'NONO_PROXY_CONFIG accepts only credentials and capture objects.',
    );
  }
  for (const key of ['credentials', 'capture']) {
    const entries = parsed[key] ?? {};
    if (
      !isObject(entries) ||
      Object.entries(entries).some(([name, value]) =>
        !/^[a-zA-Z0-9_]+$/.test(name) || !isObject(value)
      )
    ) {
      throw new Error(
        `NONO_PROXY_CONFIG ${key} must map names to configuration objects.`,
      );
    }
  }
  return expand({
    credentials: parsed.credentials ?? {},
    capture: parsed.capture ?? {},
  }) as ProxyConfig;
}
