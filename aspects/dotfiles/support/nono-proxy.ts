/**
 * Install-time helpers for the unsandboxed nono credential proxy.
 * Phantom env exports are derived from the pi profile.
 */

const ENV_VAR = /^[A-Za-z_][A-Za-z0-9_]*$/;

type Profile = {
  environment?: {set_vars?: Record<string, unknown>};
  network?: {
    credentials?: Array<string>;
    custom_credentials?: Record<string, {env_var?: unknown}>;
  };
};

/**
 * Copy explicitly selected, nonsecret set_vars into host/guest environments.
 * Do not expand host paths or read env_credentials/credential sources. Values
 * must be literal so they have the same meaning outside nono's sandbox.
 */
export function sharedEnvExports(
  profileText: string,
  names: ReadonlyArray<string>,
): string {
  const parsed = JSON.parse(stripJsoncLineComments(profileText)) as Profile;
  const credentials = new Set(
    Object.values(parsed.network?.custom_credentials ?? {}).map((cred) =>
      cred.env_var
    ),
  );
  const lines: Array<string> = [];

  for (const name of new Set(names)) {
    if (
      !ENV_VAR.test(name) || name === 'PATH' || name.startsWith('NONO_') ||
      credentials.has(name)
    ) {
      throw new Error(`Cannot share profile environment variable: ${name}`);
    }

    const value = parsed.environment?.set_vars?.[name];

    if (
      typeof value !== 'string' || /[\0$]/.test(value) || value.startsWith('~')
    ) {
      throw new Error(
        `Shared profile variable must be a literal string: ${name}`,
      );
    }

    lines.push(`export ${name}='${value.replaceAll("'", "'\\''")}'\n`);
  }

  return lines.join('');
}

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
  const parsed = JSON.parse(stripJsoncLineComments(profileText)) as Profile;
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
