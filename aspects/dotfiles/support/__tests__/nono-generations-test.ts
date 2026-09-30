import * as assert from 'node:assert/strict';
import {execFile, spawn, spawnSync} from 'node:child_process';
import {
  existsSync,
  mkdirSync,
  readFileSync,
  readdirSync,
  realpathSync,
  rmSync,
  statSync,
  symlinkSync,
  writeFileSync,
} from 'node:fs';
import {createServer} from 'node:http';
import {join} from 'node:path';
import {test} from 'node:test';
import {setTimeout as delay} from 'node:timers/promises';
import {promisify} from 'node:util';

import {generationFixture, proxyScript} from './nono-generation-fixture.ts';

const exec = promisify(execFile);

test(
  'real nono keeps old inherited policy alive while new sessions use updated policy',
  {
    skip: process.env.NONO_PROXY_INTEGRATION !== '1',
    timeout: 30_000,
  },
  async (t) => {
    const {home, state, profiles, bin, env, acquire, run} =
      await generationFixture(
        t,
      );
    // Use the real binaries, with only a disposable loopback service and CA.
    rmSync(join(bin, 'nono'));
    rmSync(join(bin, 'openssl'));
    await exec('openssl', [
      'req',
      '-x509',
      '-newkey',
      'ec',
      '-pkeyopt',
      'ec_paramgen_curve:prime256v1',
      '-nodes',
      '-keyout',
      join(state, 'ca.key'),
      '-out',
      join(state, 'ca.crt'),
      '-days',
      '1',
      '-subj',
      '/CN=proxy-generation-test',
      '-addext',
      'basicConstraints=critical,CA:TRUE',
    ]);
    writeFileSync(
      join(state, 'bundle.crt'),
      readFileSync(join(state, 'ca.crt')),
    );
    writeFileSync(
      join(profiles, 'pi.jsonc'),
      '// Preserve authored JSONC, not the incomplete show --json output.\n' +
        JSON.stringify({meta: {name: 'pi'}, extends: 'fixture-parent'}),
    );
    // Match nono's named-profile precedence: .jsonc wins over .json.
    writeFileSync(
      join(profiles, 'pi.json'),
      JSON.stringify({
        meta: {name: 'pi'},
        network: {allow_domain: ['example.invalid']},
      }),
    );
    const parent = join(profiles, 'fixture-parent.json');
    // Sibling lookup prefers .json, while global lookup prefers .jsonc.
    // Moving only pi.jsonc would silently choose this denying shadow parent.
    writeFileSync(
      join(profiles, 'fixture-parent.jsonc'),
      JSON.stringify({
        meta: {name: 'fixture-parent'},
        network: {allow_domain: ['shadowed.invalid']},
      }),
    );
    writeFileSync(
      parent,
      JSON.stringify({
        meta: {name: 'fixture-parent'},
        network: {allow_domain: ['127.0.0.1']},
        credential_capture: {
          fixture: {command: ['/usr/bin/printf', 'unused-fixture-token']},
        },
      }),
    );
    const server = createServer((_request, response) => {
      response.end('fixture');
    });
    await new Promise<void>((resolve) =>
      server.listen(0, '127.0.0.1', resolve)
    );
    t.after(() => {
      server.closeAllConnections();
      server.close();
    });
    const address = server.address();
    assert.ok(address && typeof address !== 'string');
    const old = await acquire();
    const snapshot = join(state, 'generations', old, 'profiles');
    for (
      const name of ['pi.jsonc', 'fixture-parent.json']
    ) {
      assert.equal(
        readFileSync(join(snapshot, name), 'utf8'),
        readFileSync(join(profiles, name), 'utf8'),
      );
    }
    const oldParent = readFileSync(
      join(snapshot, 'fixture-parent.json'),
      'utf8',
    );
    const oldPort = (await run(['--generation', old, 'port'])).stdout.trim();
    writeFileSync(
      parent,
      JSON.stringify({
        meta: {name: 'fixture-parent'},
        network: {allow_domain: ['example.invalid']},
      }),
    );
    const current = await acquire();
    assert.notEqual(current, old);
    assert.equal(
      readFileSync(join(snapshot, 'fixture-parent.json'), 'utf8'),
      oldParent,
    );
    const newPort = (await run(['--generation', current, 'port'])).stdout
      .trim();
    for (const [port, allowed] of [[oldPort, true], [newPort, false]]) {
      const result: {stdout: string; stderr: string} = await exec('curl', [
        '--silent',
        '--show-error',
        '--max-time',
        '5',
        '--noproxy',
        '',
        '--proxy',
        `http://127.0.0.1:${port}`,
        '--proxy-user',
        'x:fixture',
        '--output',
        '/dev/null',
        '--write-out',
        '%{http_code}',
        `http://127.0.0.1:${address.port}/fixture`,
      ], {env});
      if (allowed) {
        assert.equal(result.stdout, '200');
      } else {
        assert.match(result.stdout, /^[45][0-9]{2}$/);
      }
    }

    // A symlinked parent's canonical directory supplies transitive siblings.
    // Changing only capture arguments is invisible in profile show --json.
    const external = join(home, 'external');
    mkdirSync(external);
    rmSync(parent);
    symlinkSync(join(external, 'parent.json'), parent);
    writeFileSync(join(external, 'parent.json'), '{"extends":"grandparent"}');
    const grandparent = join(external, 'grandparent.json');
    const capture = (value: string) =>
      '// JSONC input\n' + JSON.stringify({
        network: {allow_domain: ['127.0.0.1']},
        credential_capture: {fixture: {command: ['/usr/bin/printf', value]}},
      }).replace(/}$/, ',}');
    writeFileSync(grandparent, capture('first'));
    const before =
      (await exec('nono', [
        'profile',
        'show',
        join(profiles, 'pi.jsonc'),
        '--json',
      ], {env})).stdout;
    const linked = await acquire();
    const snapParent = realpathSync(
      join(state, 'generations', linked, 'profiles/fixture-parent.json'),
    );
    const snapGrandparent = join(snapParent, '..', 'grandparent.json');
    assert.equal(readFileSync(snapGrandparent, 'utf8'), capture('first'));
    writeFileSync(grandparent, capture('second'));
    const after =
      (await exec('nono', [
        'profile',
        'show',
        join(profiles, 'pi.jsonc'),
        '--json',
      ], {env})).stdout;
    assert.equal(after, before);
    assert.notEqual(await acquire(), linked);
    assert.equal(readFileSync(snapGrandparent, 'utf8'), capture('first'));

    // Installed pack profiles also live outside the user profile directory.
    const pack = join(home, '.config/nono/packages/fixture/auth');
    mkdirSync(join(pack, 'profiles'), {recursive: true});
    writeFileSync(
      join(pack, 'package.json'),
      JSON.stringify({
        schema_version: 1,
        name: 'auth',
        description: 'fixture',
        license: 'MIT',
        platforms: ['macos', 'linux'],
        min_nono_version: '0.44.0',
        artifacts: [{
          type: 'profile',
          path: 'profiles/fixture-auth.json',
          install_as: 'fixture-auth',
        }],
      }),
    );
    writeFileSync(
      join(profiles, 'pi.jsonc'),
      '{"meta":{"name":"pi"},"extends":"fixture-auth"}',
    );
    const packed = join(pack, 'profiles/fixture-auth.json');
    writeFileSync(packed, capture('pack-first'));
    const fingerprint = async () =>
      (await exec('python3', [
        '-c',
        'import runpy,sys; print(runpy.run_path(sys.argv[1])["resolve_inputs"]()[0])',
        proxyScript,
      ], {env})).stdout;
    const packBefore = await fingerprint();
    writeFileSync(packed, capture('pack-second'));
    assert.notEqual(await fingerprint(), packBefore);
  },
);

function owner(t: {after: (fn: () => void) => void}) {
  const child = spawn(process.execPath, ['-e', 'setInterval(() => {}, 1000)']);
  t.after(() => {
    child.kill();
  });
  return child;
}

test('simultaneous launches reuse one generation; policy updates leave old clients working', async (t) => {
  const fixture = await generationFixture(t);
  const {state, profiles, acquire, run} = fixture;
  const first = owner(t);
  const second = owner(t);
  const ids = await Promise.all(
    Array.from({length: 4}, () => acquire(first.pid)),
  );
  assert.equal(new Set(ids).size, 1);
  const old = ids[0];
  const oldPort = (await run(['--generation', old, 'port'])).stdout.trim();
  const oldEnv = (await run(['--generation', old, 'env'])).stdout;
  const generation = join(state, 'generations', old);
  assert.equal(statSync(generation).mode & 0o777, 0o700);
  for (
    const file of ['profiles/pi.jsonc', 'pass', 'ca.key', 'running.json', 'log']
  ) {
    assert.equal(statSync(join(generation, file)).mode & 0o777, 0o600);
  }
  writeFileSync(join(profiles, 'pi.jsonc'), JSON.stringify({version: 2}));
  writeFileSync(join(state, 'phantoms.env'), 'export NEW_API_KEY=proxied\n');
  writeFileSync(join(state, 'ca.crt'), 'new-ca');
  const current = await acquire(second.pid);
  assert.notEqual(current, old);
  const newPort = (await run(['--generation', current, 'port'])).stdout.trim();
  assert.notEqual(newPort, oldPort);
  assert.equal((await run(['--generation', old, 'env'])).stdout, oldEnv);
  const newEnv = (await run(['--generation', current, 'env'])).stdout;
  assert.match(newEnv, /NEW_API_KEY=proxied/);
  assert.doesNotMatch(newEnv, /TEST_API_KEY/);
  assert.equal(readFileSync(join(generation, 'ca.crt'), 'utf8'), 'fixture');
  for (const [port, version] of [[oldPort, 1], [newPort, 2]]) {
    assert.equal(
      (await (await fetch(`http://127.0.0.1:${port}`)).json()).version,
      version,
    );
  }
  assert.equal((await run(['gc'])).status, 0);
  assert.equal(readdirSync(join(state, 'generations')).length, 2);
  const exited = new Promise((resolve) => first.once('exit', resolve));
  first.kill();
  await exited;
  assert.equal((await run(['gc'])).status, 0);
  assert.deepEqual(readdirSync(join(state, 'generations')), [current]);
  assert.equal((await run(['--generation', old, 'env'])).status, 1);
});

test('inherited profile, runtime, CA/auth and export changes invalidate reuse, not token refresh', async (t) => {
  const {state, profiles, bin, acquire} = await generationFixture(t);
  writeFileSync(join(profiles, 'pi.jsonc'), '{"extends":"base"}');
  writeFileSync(join(profiles, 'base.json'), '{}');
  let previous = await acquire();
  const changes = [
    [
      join(profiles, 'base.json'),
      '{"network":{"allow_domain":["fixture.example"]}}',
    ],
    [join(state, 'bundle.crt'), 'new roots'],
    [join(state, 'ca.key'), 'new key'],
    [join(state, 'pass'), 'new password'],
    [join(state, 'shared.env'), 'export SERVICE_SITE=changed.example\n'],
    [
      join(bin, 'nono'),
      readFileSync(join(bin, 'nono'), 'utf8') + '\n# new binary version\n',
    ],
  ];
  for (const [path, text] of changes) {
    writeFileSync(path, text);
    const next = await acquire();
    assert.notEqual(next, previous, path);
    assert.equal(await acquire(), next);
    previous = next;
  }
  // Auth helper token caches aren't configuration and aren't inspected.
  writeFileSync(join(state, 'token-cache'), 'new disposable token');
  writeFileSync(
    join(profiles, 'unrelated.json'),
    'unfinished unrelated profile',
  );
  assert.equal(await acquire(), previous);
});

test('failed or timed-out startup emits no exports, preserves old generation, and leaves no partial state', async (t) => {
  const {state, profiles, acquire, run} = await generationFixture(t);
  const old = await acquire();
  writeFileSync(join(profiles, 'pi.jsonc'), '{"version":2}');
  for (const mode of ['fail', 'timeout']) {
    const result = await run(['acquire', String(process.pid)], {
      FIXTURE_START_MODE: mode,
      NONO_PROXY_START_TIMEOUT_SECS: '0.2',
    });
    assert.notEqual(result.status, 0);
    assert.equal(result.stdout, '');
    assert.doesNotMatch(result.stderr, /PRIVATE-FAILURE-TEXT/);
    assert.deepEqual(readdirSync(join(state, 'generations')), [old]);
    assert.equal((await run(['--generation', old, 'env'])).status, 0);
  }
});

test('manual exports are pinned, guest exports use the selected generation and per-connection port', async (t) => {
  const {state, profiles, acquire, run} = await generationFixture(t);
  const id = await acquire();
  const manual = await run(['env']);
  assert.equal(manual.status, 0);
  assert.match(manual.stdout, /unset http_proxy https_proxy/);
  const cleared = await run(['--generation', id, 'env'], {
    NONO_PROXY_EXPORTS: 'OBSOLETE_API_KEY',
  });
  assert.match(cleared.stdout, /^unset OBSOLETE_API_KEY$/m);
  assert.equal(
    await acquire(process.pid, {NONO_PROXY_EXPORTS: 'OBSOLETE_API_KEY'}),
    id,
  );
  writeFileSync(join(profiles, 'pi.jsonc'), '{"version":2}');
  await acquire();
  // Simulate a dead/recycled lease. Manual use must still retain the generation.
  const path = join(state, 'generations', id, 'running.json');
  const record = JSON.parse(readFileSync(path, 'utf8'));
  record.leases = {'99999999': 'stale'};
  writeFileSync(path, JSON.stringify(record));
  await run(['gc']);
  assert.equal(
    (await run(['--generation', id, 'port'])).stdout.trim(),
    String(record.port),
  );
  const guest = await run([
    '--generation',
    id,
    '--guest-port',
    '54321',
    'guest-env',
    '/guest/ca',
    '/guest/bundle',
  ]);
  assert.equal(guest.status, 0);
  assert.match(guest.stdout, /127\.0\.0\.1:54321/);
  assert.match(guest.stdout, /NODE_EXTRA_CA_CERTS=\/guest\/ca/);
  assert.match(guest.stdout, /TEST_API_KEY=proxied/);
  assert.doesNotMatch(guest.stdout, new RegExp(state));
  assert.notEqual((await run(['--generation', '../escape', 'env'])).status, 0);
});

test('capture helpers use a stable host cwd, independent of the launching repository', async (t) => {
  const {home, profiles, acquire, run} = await generationFixture(t);
  const first = join(home, 'first-repo');
  const second = join(home, 'second-repo');
  mkdirSync(first);
  mkdirSync(second);
  writeFileSync(
    join(profiles, 'pi.jsonc'),
    JSON.stringify({capture_cwd: '$PWD'}),
  );
  const id = await acquire(process.pid, {PWD: first}, first);
  assert.equal(await acquire(process.pid, {PWD: second}, second), id);
  const port = (await run(['--generation', id, 'port'])).stdout.trim();
  const reply = await (await fetch(`http://127.0.0.1:${port}`)).json();
  assert.equal(reply.cwd, realpathSync(home));
  assert.equal(reply.pwd, realpathSync(home));
});

test('lease-scoped scratch directories are private, short, and collected after owner exit', async (t) => {
  const {acquire, run} = await generationFixture(t);
  const client = owner(t);
  const id = await acquire(client.pid);
  const result = await run([
    '--generation',
    id,
    'lease-dir',
    String(client.pid),
  ]);
  assert.equal(result.status, 0, result.stderr);
  const directory = result.stdout.trim();
  assert.ok(directory.length < 80);
  assert.equal(statSync(directory).mode & 0o777, 0o700);
  assert.equal(
    (await run(['--generation', id, 'lease-dir', String(client.pid)])).stdout
      .trim(),
    directory,
  );
  assert.notEqual(
    (await run(['--generation', id, 'lease-dir', String(process.pid)])).status,
    0,
  );
  const exited = new Promise((resolve) => client.once('exit', resolve));
  client.kill();
  await exited;
  assert.equal((await run(['gc'])).status, 0);
  assert.equal(existsSync(directory), false);
});

test('an invalid or expired installed CA prevents reuse without stopping old clients', async (t) => {
  const {bin, acquire, run} = await generationFixture(t);
  const id = await acquire();
  writeFileSync(join(bin, 'openssl'), '#!/bin/sh\nexit 1\n');
  const result = await run(['acquire', String(process.pid)]);
  assert.equal(result.status, 1);
  assert.equal(result.stdout, '');
  assert.match(result.stderr, /CA.*expired.*install dotfiles/);
  assert.equal((await run(['--generation', id, 'port'])).status, 0);
});

async function waitForStartup(state: string) {
  for (let count = 0; count < 100; count++) {
    try {
      const dirs = readdirSync(join(state, 'generations'));
      for (const dir of dirs) {
        try {
          return JSON.parse(
            readFileSync(
              join(state, 'generations', dir, 'starting.json'),
              'utf8',
            ),
          );
        } catch {}
      }
    } catch {}
    await delay(20);
  }
  throw new Error('fixture proxy did not reach startup');
}

test('edits during startup retry before publishing a current generation', async (t) => {
  const {state, profiles, acquire} = await generationFixture(t);
  const started = acquire(process.pid, {FIXTURE_START_MODE: 'delay'});
  await waitForStartup(state);
  writeFileSync(join(profiles, 'pi.jsonc'), '{"version":2}');
  const id = await started;
  assert.equal(
    JSON.parse(
      readFileSync(join(state, 'generations', id, 'profiles/pi.jsonc'), 'utf8'),
    ).version,
    2,
  );
  assert.deepEqual(readdirSync(join(state, 'generations')), [id]);
});

test('a killed launcher releases its lock and the next command cleans up its unpublished proxy', async (t) => {
  const {state, env, run} = await generationFixture(t);
  const launcher = spawn(proxyScript, ['acquire', String(process.pid)], {
    env: {...env, FIXTURE_START_MODE: 'delay'},
    stdio: 'ignore',
  });
  t.after(() => {
    launcher.kill();
  });
  const record = await waitForStartup(state);
  const exited = new Promise((resolve) => launcher.once('exit', resolve));
  launcher.kill('SIGKILL');
  await exited;
  const result = await run(['gc']);
  assert.equal(result.status, 0, result.stderr);
  assert.deepEqual(readdirSync(join(state, 'generations')), []);
  const ps = spawnSync('ps', ['-p', String(record.pid), '-o', 'stat='], {
    encoding: 'utf8',
  });
  assert.ok(ps.status !== 0 || ps.stdout.trim().startsWith('Z'));
});

test('pi-naked fails closed on acquire/export errors and preserves lease PID through exec', async (t) => {
  const {bin, env} = await generationFixture(t);
  const wrapper = new URL('../../../../bin/pi-naked', import.meta.url).pathname;
  writeFileSync(join(bin, 'uname'), '#!/bin/sh\necho Darwin\n', {mode: 0o755});
  writeFileSync(
    join(bin, 'pi'),
    '#!/bin/sh\nprintf "pi:%s:%s" "$$" "$LEASE_OWNER"\n',
    {mode: 0o755},
  );
  for (const failure of ['acquire', 'env']) {
    writeFileSync(
      join(bin, 'nono-proxy'),
      `#!/bin/sh
case "$*" in *${failure}*) exit 42 ;; esac
echo fixture
`,
      {mode: 0o755},
    );
    const result = spawnSync('/bin/bash', [wrapper], {env, encoding: 'utf8'});
    assert.equal(result.status, 42);
    assert.equal(result.stdout, '');
  }
  writeFileSync(
    join(bin, 'nono-proxy'),
    '#!/bin/sh\nif [ "$1" = acquire ]; then echo "$2"; else echo "export LEASE_OWNER=$2"; fi\n',
    {mode: 0o755},
  );
  const result = spawnSync('/bin/bash', [wrapper], {env, encoding: 'utf8'});
  assert.equal(result.status, 0, result.stderr);
  const [, pid, lease] = result.stdout.split(':');
  assert.equal(pid, lease);
});
