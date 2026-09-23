import * as assert from 'node:assert/strict';
import {spawnSync} from 'node:child_process';
import {
  mkdirSync,
  mkdtempSync,
  readFileSync,
  readdirSync,
  rmSync,
  statSync,
  writeFileSync,
} from 'node:fs';
import {tmpdir} from 'node:os';
import {join} from 'node:path';
import {test} from 'node:test';
import {fileURLToPath} from 'node:url';

import {
  phantomEnvExports,
  proxyEnvExports,
  sharedEnvExports,
  stripJsoncLineComments,
} from '../nono-proxy.ts';

import {renderFixtureProfile} from './nono-profile-fixture.ts';

const proxy = fileURLToPath(
  new URL('../../files/.zsh/bin/nono-proxy', import.meta.url),
);
const sb = readFileSync(
  new URL('../../templates/.zsh/bin/sb.erb', import.meta.url),
  'utf8',
);

function fixture(t: {after: (fn: () => void) => void}) {
  const home = mkdtempSync(join(tmpdir(), 'nono-proxy-test-'));
  t.after(() => rmSync(home, {recursive: true, force: true}));
  const state = join(home, '.local/state/nono-proxy');
  mkdirSync(state, {recursive: true});
  for (const name of ['ca.crt', 'ca.key', 'bundle.crt', 'pass']) {
    writeFileSync(join(state, name), 'fixture');
  }
  writeFileSync(join(state, 'phantoms.env'), 'export TEST_API_KEY=proxied\n');
  writeFileSync(
    join(state, 'shared.env'),
    sharedEnvExports(profile, ['SERVICE_SITE', 'SERVICE_EMAIL']),
  );
  return {home, state};
}

const profile = JSON.stringify({
  environment: {
    set_vars: {
      SERVICE_SITE: 'fixture.example',
      SERVICE_EMAIL: "o'brien@example.com",
      XDG_CACHE_HOME: '$TMPDIR/cache',
      UNSELECTED: 'host-only',
      SCRIPT_TEXT: "$(touch nope); `touch nope`; 'quoted'\nnext line",
      LITERAL_TEXT: "a; `echo not-executed`; 'quoted'\nnext line",
    },
  },
  network: {
    custom_credentials: {
      service: {
        env_var: 'TEST_API_KEY',
        credential_key: 'op://vault/item/field',
      },
      duplicate: {env_var: 'TEST_API_KEY'},
      invalid: {env_var: 'BAD-NAME'},
      missing: {},
    },
  },
});

test('phantom exports preserve op URIs when stripping comments and deduplicate names', () => {
  assert.equal(
    phantomEnvExports('// A comment\n' + profile),
    'export TEST_API_KEY=proxied\n',
  );
  assert.equal(phantomEnvExports('{}'), '');
});

test('shared exports copy only explicitly selected literal metadata', () => {
  assert.equal(sharedEnvExports(profile, []), '');
  assert.equal(
    sharedEnvExports(profile, [
      'SERVICE_SITE',
      'SERVICE_EMAIL',
      'SERVICE_SITE',
    ]),
    "export SERVICE_SITE='fixture.example'\nexport SERVICE_EMAIL='o'\\''brien@example.com'\n",
  );
});

test('shared exports reject missing, invalid, reserved, credential and expanding values', () => {
  for (
    const name of [
      'MISSING',
      'BAD-NAME',
      'PATH',
      'NONO_TEST',
      'TEST_API_KEY',
      'XDG_CACHE_HOME',
      'SCRIPT_TEXT',
    ]
  ) {
    assert.throws(() => sharedEnvExports(profile, [name]), /profile|Shared/);
  }
  for (const value of [1, null, '~/host/path', 'nul\0byte']) {
    assert.throws(() =>
      sharedEnvExports(
        JSON.stringify({environment: {set_vars: {TEST: value}}}),
        ['TEST'],
      )
    );
  }
});

test('shared exports round-trip quotes, newlines and shell metacharacters without evaluation', () => {
  const exports = sharedEnvExports(profile, ['SERVICE_EMAIL', 'LITERAL_TEXT']);
  const result = spawnSync('/bin/bash', [
    '-c',
    exports + '\nprintf "%s\\0%s" "$SERVICE_EMAIL" "$LITERAL_TEXT"',
  ], {encoding: 'utf8'});
  assert.equal(result.status, 0, result.stderr);
  assert.equal(
    result.stdout,
    "o'brien@example.com\0a; `echo not-executed`; 'quoted'\nnext line",
  );
});

test('guest-env requires both guest paths and exports safely quoted CA and phantom values', (t) => {
  const {home} = fixture(t);
  const env = {PATH: process.env.PATH, HOME: home};
  const ca = "/home/fixture/it's a CA; `echo bad`/ca.crt";
  const bundle = '/home/fixture/roots and proxy/bundle.crt';
  const result = spawnSync('/bin/bash', [proxy, 'guest-env', ca, bundle], {
    env,
    encoding: 'utf8',
  });
  assert.equal(result.status, 0, result.stderr);
  const evaluated = spawnSync('/bin/bash', [
    '-c',
    result.stdout +
    '\nprintf "%s\\0" "$NODE_EXTRA_CA_CERTS" "$CURL_CA_BUNDLE" "$SSL_CERT_FILE" "$REQUESTS_CA_BUNDLE" "$TEST_API_KEY" "$HTTPS_PROXY"',
  ], {env, encoding: 'utf8'});
  assert.equal(evaluated.status, 0, evaluated.stderr);
  assert.deepEqual(evaluated.stdout.split('\0'), [
    ca,
    bundle,
    bundle,
    bundle,
    'proxied',
    'http://x:fixture@127.0.0.1:18099',
    '',
  ]);
  for (const args of [[], [ca]]) {
    const missing = spawnSync('/bin/bash', [proxy, 'guest-env', ...args], {
      env,
      encoding: 'utf8',
    });
    assert.notEqual(missing.status, 0);
    assert.equal(missing.stdout, '');
    assert.match(missing.stderr, /guest CA and combined bundle paths/);
  }
});

test('host and guest exports share metadata and replace inherited credential values', (t) => {
  const {home, state} = fixture(t);
  const bin = join(home, 'bin');
  mkdirSync(bin);
  // Avoid real certificate checks, sockets or proxy startup in this unit test.
  for (const name of ['nc', 'openssl']) {
    writeFileSync(join(bin, name), '#!/bin/sh\nexit 0\n', {mode: 0o755});
  }
  const env = {
    PATH: `${bin}:${process.env.PATH}`,
    HOME: home,
    TEST_API_KEY: 'obsolete-fixture-value',
    SERVICE_SITE: 'obsolete-fixture-site',
  };
  for (
    const args of [['env'], ['guest-env', '/guest/ca.crt', '/guest/bundle.crt']]
  ) {
    const result = spawnSync('/bin/bash', [proxy, ...args], {
      env,
      encoding: 'utf8',
    });
    assert.equal(result.status, 0, result.stderr);
    const evaluated = spawnSync('/bin/bash', [
      '-c',
      result.stdout +
      '\nprintf "%s\\0" "$SERVICE_SITE" "$SERVICE_EMAIL" "$TEST_API_KEY"',
    ], {env, encoding: 'utf8'});
    assert.equal(evaluated.status, 0, evaluated.stderr);
    assert.deepEqual(evaluated.stdout.split('\0'), [
      'fixture.example',
      "o'brien@example.com",
      'proxied',
      '',
    ]);
  }
  rmSync(join(state, 'shared.env'));
  const missing = spawnSync('/bin/bash', [proxy, 'env'], {
    env,
    encoding: 'utf8',
  });
  assert.notEqual(missing.status, 0);
  assert.equal(missing.stdout, '');
  assert.match(missing.stderr, /run `\.\/install dotfiles`/);
});

test('the rendered profile exports fixture metadata and a placeholder without sandbox paths', () => {
  const source = renderFixtureProfile();
  assert.equal(
    sharedEnvExports(source, ['ATLASSIAN_SITE', 'ATLASSIAN_EMAIL']),
    "export ATLASSIAN_SITE='example.atlassian.net'\nexport ATLASSIAN_EMAIL='operator@example.com'\n",
  );
  assert.match(
    phantomEnvExports(source),
    /^export ATLASSIAN_API_KEY=proxied$/m,
  );
  assert.doesNotMatch(phantomEnvExports(source), /op:\/\/|XDG_/);
});

test('proxy exports follow optional metadata in the installed profile', () => {
  const source = renderFixtureProfile();
  assert.deepEqual(proxyEnvExports(source), {
    shared: sharedEnvExports(source, ['ATLASSIAN_SITE', 'ATLASSIAN_EMAIL']),
    phantoms: phantomEnvExports(source),
  });

  const withoutAtlassian = renderFixtureProfile(null);
  const exports = proxyEnvExports(withoutAtlassian);
  assert.equal(exports.shared, '');
  assert.equal(exports.phantoms, phantomEnvExports(withoutAtlassian));
  assert.doesNotMatch(exports.phantoms, /ATLASSIAN_API_KEY/);
  assert.deepEqual(proxyEnvExports('{}'), {shared: '', phantoms: ''});

  // Unselected profile variables stay private; selected values still receive
  // the existing literal-value and shell-quoting checks.
  assert.equal(proxyEnvExports(profile).shared, '');
  assert.equal(
    proxyEnvExports(JSON.stringify({
      environment: {set_vars: {ATLASSIAN_EMAIL: "o'brien@example.com"}},
    })).shared,
    "export ATLASSIAN_EMAIL='o'\\''brien@example.com'\n",
  );
  assert.throws(() =>
    proxyEnvExports(JSON.stringify({
      environment: {set_vars: {ATLASSIAN_SITE: '$HOST'}},
    }))
  );
});

test('the Atlassian route allows all operations but binds credentials to the exact tenant', () => {
  const source = JSON.parse(stripJsoncLineComments(renderFixtureProfile()));
  const route = source.network.custom_credentials.atlassian;
  assert.equal(route.endpoint_rules, undefined);
  assert.equal(route.upstream, 'https://example.atlassian.net');
  assert.equal(route.inject_mode, 'basic_auth');
  assert.equal(route.credential_key, 'op://CLI/atlassian-api-key/credential');
  assert.deepEqual(route.endpoint_policy, {default: {decision: 'allow'}});
});

test('guest bundle script combines native roots and proxy CA atomically and without accumulation', (t) => {
  const {home} = fixture(t);
  const script = sb.match(/<<'CA_BUNDLE'\n([\s\S]*?)\nCA_BUNDLE\n/)?.[1];
  assert.ok(script);
  const ca = join(home, 'proxy CA.crt');
  const roots = join(home, 'native roots.crt');
  const bundle = join(home, 'combined bundle.crt');
  writeFileSync(ca, 'proxy-ca\n');
  writeFileSync(roots, 'native-roots');
  const run = () =>
    spawnSync('/bin/bash', ['-s', '--', ca, bundle, roots], {
      input: script,
      encoding: 'utf8',
    });
  let result = run();
  assert.equal(result.status, 0, result.stderr);
  assert.equal(readFileSync(bundle, 'utf8'), 'native-roots\nproxy-ca\n');
  assert.equal(statSync(bundle).mode & 0o777, 0o600);
  writeFileSync(ca, 'rotated-ca\n');
  result = run();
  assert.equal(result.status, 0, result.stderr);
  assert.equal(readFileSync(bundle, 'utf8'), 'native-roots\nrotated-ca\n');
  rmSync(roots);
  result = run();
  assert.notEqual(result.status, 0);
  assert.equal(readFileSync(bundle, 'utf8'), 'native-roots\nrotated-ca\n');
  assert.equal(
    readdirSync(home).filter((name) => name.startsWith('combined bundle.crt.'))
      .length,
    0,
  );
});
