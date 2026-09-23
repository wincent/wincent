import * as assert from 'node:assert/strict';
import {test} from 'node:test';

import {
  readAtlassianMetadata,
  shouldPreserveProfile,
} from '../atlassian-metadata.ts';
import {phantomEnvExports, stripJsoncLineComments} from '../nono-proxy.ts';
import {fixtureMetadata, renderFixtureProfile} from './nono-profile-fixture.ts';

test('metadata reads only site/email, with a fallback account before shell setup', async () => {
  const calls: Array<[string, string]> = [];
  const result = await readAtlassianMetadata({
    account: '',
    read: async (field, account) => {
      calls.push([field, account]);
      return fixtureMetadata[field] + '\n';
    },
  });
  assert.deepEqual(calls, [['site', 'my.1password.eu'], [
    'email',
    'my.1password.eu',
  ]]);
  assert.deepEqual(result, {status: 'available', metadata: fixtureMetadata});
  assert.equal(shouldPreserveProfile(result, true), false);
});

test('metadata honors an explicit account and normalizes the hostname', async () => {
  const result = await readAtlassianMetadata({
    account: 'other-account',
    read: async (field, account) => {
      assert.equal(account, 'other-account');
      return field === 'site'
        ? 'EXAMPLE.atlassian.net\n'
        : fixtureMetadata.email;
    },
  });
  assert.deepEqual(result, {status: 'available', metadata: fixtureMetadata});
});

test('missing op/auth failure is optional and does not retry or expose subprocess output', async () => {
  let calls = 0;
  const result = await readAtlassianMetadata({
    read: async () => {
      calls++;
      throw new Error('private diagnostic which must not escape');
    },
  });
  assert.equal(calls, 1);
  assert.deepEqual(result, {status: 'unavailable', metadata: null});
  assert.equal(shouldPreserveProfile(result, false), false);
  assert.equal(shouldPreserveProfile(result, true), true);
});

test('a failed second field discards partial metadata and preserves an existing profile', async () => {
  const result = await readAtlassianMetadata({
    read: async (field) => {
      if (field === 'site') {
        return fixtureMetadata.site;
      }
      throw new Error('cancelled');
    },
  });
  assert.deepEqual(result, {status: 'unavailable', metadata: null});
  assert.equal(shouldPreserveProfile(result, true), true);
});

test('dry runs and VMs can skip 1Password entirely', async () => {
  const result = await readAtlassianMetadata({
    enabled: false,
    read: async () => {
      throw new Error('must not run');
    },
  });
  assert.deepEqual(result, {status: 'skipped', metadata: null});
  assert.equal(shouldPreserveProfile(result, false), false);
  assert.equal(shouldPreserveProfile(result, true), true);
});

test('invalid or expansion-bearing metadata never produces a partial route', async () => {
  const values = [
    {site: '', email: fixtureMetadata.email},
    {site: 'https://example.atlassian.net', email: fixtureMetadata.email},
    {site: '*.atlassian.net', email: fixtureMetadata.email},
    {site: 'example.atlassian.net:443', email: fixtureMetadata.email},
    {site: 'example.atlassian.net/other', email: fixtureMetadata.email},
    {site: 'example.atlassian.net.evil.test', email: fixtureMetadata.email},
    {site: fixtureMetadata.site, email: ''},
    {site: fixtureMetadata.site, email: 'a@example.com\nINJECTED'},
    {site: fixtureMetadata.site, email: '$USER@example.com'},
    {site: fixtureMetadata.site, email: '~user@example.com'},
    {site: fixtureMetadata.site, email: 'a@example.com:token'},
  ];
  for (const metadata of values) {
    const result = await readAtlassianMetadata({
      read: async (field) => metadata[field],
    });
    assert.deepEqual(result, {status: 'invalid', metadata: null});
    assert.equal(shouldPreserveProfile(result, true), true);
  }
});

test('first-run template has no Atlassian route or exports', () => {
  const rendered = renderFixtureProfile(null);
  const parsed = JSON.parse(stripJsoncLineComments(rendered));
  assert.equal(parsed.network.custom_credentials.atlassian, undefined);
  assert.equal(parsed.network.credentials.includes('atlassian'), false);
  assert.equal(parsed.environment.set_vars.ATLASSIAN_SITE, undefined);
  assert.equal(parsed.environment.set_vars.ATLASSIAN_EMAIL, undefined);
  assert.doesNotMatch(phantomEnvExports(rendered), /ATLASSIAN/);
  assert.match(phantomEnvExports(rendered), /ANTHROPIC_API_KEY=proxied/);
});

test('second-run template activates the exact tenant with escaped metadata and an op reference only', () => {
  const metadata = {...fixtureMetadata, email: "o'brien@example.com"};
  const rendered = renderFixtureProfile(metadata);
  const parsed = JSON.parse(stripJsoncLineComments(rendered));
  assert.equal(parsed.network.credentials.includes('atlassian'), true);
  const route = parsed.network.custom_credentials.atlassian;
  assert.equal(route.upstream, 'https://example.atlassian.net');
  assert.equal(route.credential_key, 'op://CLI/atlassian-api-key/credential');
  assert.equal(parsed.environment.set_vars.ATLASSIAN_EMAIL, metadata.email);
  assert.match(phantomEnvExports(rendered), /ATLASSIAN_API_KEY=proxied/);
});
