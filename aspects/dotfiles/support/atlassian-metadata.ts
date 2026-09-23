import {execFile} from 'node:child_process';
import {promisify} from 'node:util';

const exec = promisify(execFile);

type ReadField = (field: 'site' | 'email', account: string) => Promise<string>;

export type AtlassianMetadata = {site: string; email: string};

export type MetadataResult =
  | {status: 'available'; metadata: AtlassianMetadata}
  | {status: 'unavailable' | 'invalid' | 'skipped'; metadata: null};

async function readField(
  field: 'site' | 'email',
  account: string,
): Promise<string> {
  // Never fetch the item as a whole: that would also expose its credential.
  // Capture output privately, bound biometric/auth waits, and never log stderr.
  const result = await exec('op', [
    'read',
    '--account',
    account,
    `op://CLI/atlassian-api-key/${field}`,
  ], {encoding: 'utf8', timeout: 30_000, maxBuffer: 64 * 1024});
  return result.stdout;
}

/** Read only optional site/email metadata, without requiring shell setup. */
export async function readAtlassianMetadata({
  enabled = true,
  account = process.env.OP_ACCOUNT,
  read = readField,
}: {
  enabled?: boolean;
  account?: string;
  read?: ReadField;
} = {}): Promise<MetadataResult> {
  if (!enabled) {
    return {status: 'skipped', metadata: null};
  }

  try {
    const selectedAccount = account?.trim() || 'my.1password.eu';
    const site = (await read('site', selectedAccount)).trim().toLowerCase();
    const email = (await read('email', selectedAccount)).trim();

    // One exact tenant host, without URL syntax, ports or wildcards. Reject
    // expansion syntax in email too: nono expands set_vars before injection.
    if (
      !/^[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?\.atlassian\.net$/.test(site) ||
      !/^[^@\s:$\x00-\x1f]+@[^@\s:$\x00-\x1f]+$/.test(email) ||
      email.startsWith('~')
    ) {
      return {status: 'invalid', metadata: null};
    }

    return {status: 'available', metadata: {site, email}};
  } catch {
    // Includes missing op, unavailable account/app, missing fields, timeouts,
    // and cancelled authorization. Do not expose captured output in warnings.
    return {status: 'unavailable', metadata: null};
  }
}

/** Preserve an installed profile if optional metadata cannot be refreshed. */
export function shouldPreserveProfile(
  result: MetadataResult,
  installed: boolean,
): boolean {
  return installed && result.status !== 'available';
}
