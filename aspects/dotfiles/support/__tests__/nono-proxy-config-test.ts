import * as assert from 'node:assert/strict';
import {mkdtemp, rm, writeFile} from 'node:fs/promises';
import {tmpdir} from 'node:os';
import {join} from 'node:path';
import {test} from 'node:test';

import {readProxyConfig} from '../nono-proxy-config.ts';
import {proxyEnvExports, stripJsoncLineComments} from '../nono-proxy.ts';
import {renderFixtureProfile} from './nono-profile-fixture.ts';

const local = {
  credentials: {
    fixture: {
      upstream: '$PRIVATE_ORIGIN',
      credential_key: 'cmd://fixture',
      inject_header: 'Authorization',
      credential_format: 'Bearer {}',
      env_var: 'FIXTURE_API_KEY',
      endpoint_rules: [{method: 'POST', path: '/v1/messages'}],
    },
  },
  capture: {
    fixture: {
      command: ['fixture-auth', 'token', '$PRIVATE_AUDIENCE'],
      timeout_secs: 30,
      cache_ttl_secs: 0,
    },
  },
};

test('private proxy config is optional, then becomes available after machine setup', async (t) => {
  const dir = await mkdtemp(join(tmpdir(), 'nono-local-config-'));
  t.after(() => rm(dir, {recursive: true, force: true}));
  const file = join(dir, 'proxy.json');
  const env = {
    NONO_PROXY_CONFIG: file,
    PRIVATE_ORIGIN: 'https://service.example.com',
    PRIVATE_AUDIENCE: 'fixture',
  };
  const empty = {credentials: {}, capture: {}};
  assert.deepEqual(await readProxyConfig({}), empty);
  assert.deepEqual(await readProxyConfig(env), empty);

  await writeFile(file, JSON.stringify(local));
  const config = await readProxyConfig(env);
  assert.equal(config.credentials.fixture.upstream, env.PRIVATE_ORIGIN);
  assert.deepEqual(config.capture.fixture.command, [
    'fixture-auth',
    'token',
    'fixture',
  ]);
  const text = renderFixtureProfile(null, config);
  const rendered = JSON.parse(stripJsoncLineComments(text));
  assert.ok(rendered.network.credentials.includes('fixture'));
  assert.ok(rendered.network.credentials.includes('anthropic_api_key'));
  assert.deepEqual(
    rendered.network.custom_credentials.fixture,
    config.credentials.fixture,
  );
  assert.deepEqual(rendered.credential_capture, config.capture);
  assert.match(
    proxyEnvExports(text).phantoms,
    /^export FIXTURE_API_KEY=proxied$/m,
  );
  assert.doesNotMatch(
    proxyEnvExports(text).shared,
    /PRIVATE_|service\.example/,
  );

  await assert.rejects(
    () => readProxyConfig({NONO_PROXY_CONFIG: file}),
    /requires environment variable/,
  );
  // Replacement values are data, not shell commands, and are not expanded again.
  const opaque = 'literal $(not-executed) $OTHER "quoted"';
  assert.equal(
    (await readProxyConfig({...env, PRIVATE_ORIGIN: opaque})).credentials
      .fixture.upstream,
    opaque,
  );
});

test('invalid private config fails without printing its contents', async (t) => {
  const dir = await mkdtemp(join(tmpdir(), 'nono-local-invalid-'));
  t.after(() => rm(dir, {recursive: true, force: true}));
  const file = join(dir, 'proxy.json');
  for (
    const value of [
      'private invalid contents',
      'null',
      '[]',
      '{"filesystem":{}}',
      '{"credentials":[]}',
      '{"capture":{"bad-name":{}}}',
      '{"credentials":{"fixture":42}}',
    ]
  ) {
    await writeFile(file, value);
    await assert.rejects(
      () => readProxyConfig({NONO_PROXY_CONFIG: file}),
      (error: Error) => {
        assert.match(error.message, /NONO_PROXY_CONFIG/);
        assert.ok(!error.message.includes(value));
        return true;
      },
    );
  }
  await assert.rejects(() => readProxyConfig({NONO_PROXY_CONFIG: dir}));
});

test('empty private config does not alter the profile and duplicate routes fail', () => {
  const plain = JSON.parse(stripJsoncLineComments(renderFixtureProfile(null)));
  assert.equal(plain.credential_capture, undefined);
  assert.ok(!plain.network.credentials.includes('fixture'));
  assert.throws(() =>
    renderFixtureProfile(null, {
      credentials: {
        anthropic_api_key: {upstream: 'https://service.example.com'},
      },
      capture: {},
    }), /conflicts with built-in route/);
});
