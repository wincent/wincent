/**
 * Install-time helpers for the unsandboxed nono credential proxy.
 * Phantom env exports are derived from the pi profile.
 */

const ENV_VAR = /^[A-Za-z_][A-Za-z0-9_]*$/;

/**
 * Drop full-line `//` comments. Does not touch `//` inside strings
 * (needed for `op://` URIs in the profile).
 */
export function stripJsoncLineComments(text: string): string {
  return text.replace(/^\s*\/\/.*$/gm, '');
}

/**
 * `export NAME=proxied` lines for each `custom_credentials.*.env_var`
 * in a nono profile. Callers eval this so clients that require a
 * variable to be set (Pi's `web_search`, provider availability)
 * still make the request; the proxy overwrites the header.
 */
export function phantomEnvExports(profileText: string): string {
  const parsed = JSON.parse(stripJsoncLineComments(profileText)) as {
    network?: {
      custom_credentials?: Record<string, {env_var?: unknown}>;
    };
  };
  const names: Array<string> = [];
  const seen = new Set<string>();

  for (
    const cred of Object.values(parsed.network?.custom_credentials ?? {})
  ) {
    const name = cred.env_var;

    if (typeof name !== 'string' || !ENV_VAR.test(name) || seen.has(name)) {
      continue;
    }

    seen.add(name);
    names.push(name);
  }

  return names.map((name) => `export ${name}=proxied\n`).join('');
}
