import {readFileSync} from 'node:fs';

import {compile, fill} from '../../../../fig/template.ts';
import type {AtlassianMetadata} from '../atlassian-metadata.ts';

export const fixtureMetadata = {
  site: 'example.atlassian.net',
  email: 'operator@example.com',
};
export const profileTemplate: string = readFileSync(
  new URL(
    '../../templates/.config/nono/profiles/pi.jsonc.erb',
    import.meta.url,
  ),
  'utf8',
);

export function renderFixtureProfile(
  metadata: AtlassianMetadata | null = fixtureMetadata,
): string {
  return fill(compile(profileTemplate), {
    variables: {
      figManaged: 'Managed by Fig (test fixture)',
      atlassianSite: metadata?.site ?? '',
      atlassianEmail: metadata?.email ?? '',
    },
  });
}
