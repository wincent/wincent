import * as assert from 'node:assert/strict';
import {spawnSync} from 'node:child_process';
import {
  chmodSync,
  existsSync,
  mkdirSync,
  mkdtempSync,
  readFileSync,
  rmSync,
  statSync,
  symlinkSync,
  writeFileSync,
} from 'node:fs';
import {tmpdir} from 'node:os';
import {dirname, join} from 'node:path';
import {test} from 'node:test';
import {fileURLToPath} from 'node:url';

import {stripJsoncLineComments} from '../nono-proxy.ts';
import {renderFixtureProfile} from './nono-profile-fixture.ts';

const launcher = fileURLToPath(new URL('../../../../bin/pi', import.meta.url));

function fixture(t: {after: (fn: () => void) => void}) {
  const dir = mkdtempSync(join(tmpdir(), 'pi-launch-'));
  t.after(() => rmSync(dir, {recursive: true, force: true}));
  const bin = join(dir, 'bin');
  const temp = join(dir, 'temp space');
  const root = join(temp, 'pi-sockets');
  mkdirSync(bin);
  mkdirSync(temp);
  function script(name: string, source: string) {
    writeFileSync(join(bin, name), '#!/bin/bash\n' + source, {mode: 0o755});
  }
  script('uname', 'printf "%s\\n" "$FIXTURE_OS"\n');
  script(
    'nono',
    '[ -d "$TMPDIR/pi-sockets" ] || exit 93\n' +
      'printf "%s\\0" nono "$PI_SUBAGENT_LAUNCHER" "$TMPDIR" "$(umask)" "$@"\n',
  );
  script('pi', 'printf "%s\\0" pi "$PI_SUBAGENT_LAUNCHER" "$@"\n');
  const env = {
    ...process.env,
    PATH: `${bin}:/usr/bin:/bin`,
    TMPDIR: temp + '/',
    FIXTURE_OS: 'Darwin',
  };
  const run = (overrides: NodeJS.ProcessEnv = {}, args: string[] = []) =>
    spawnSync('/bin/bash', [
      '-c',
      'umask 022; exec "$@"',
      'fixture',
      launcher,
      ...args,
    ], {env: {...env, ...overrides}, encoding: 'utf8'});
  return {bin, temp, root, run, script};
}

test('Pi launcher creates a private socket root before nono without altering arguments or umask', (t) => {
  const {root, temp, run} = fixture(t);
  const args = ['--model', 'model with spaces', 'a; $(not-executed)'];
  const result = run({}, args);
  assert.equal(result.status, 0, result.stderr);
  assert.equal(statSync(root).mode & 0o777, 0o700);
  assert.deepEqual(result.stdout.split('\0'), [
    'nono',
    launcher,
    temp + '/',
    '0022',
    'run',
    '--profile',
    'pi',
    '--allow-cwd',
    '--',
    'pi',
    ...args,
    '',
  ]);
});

test('Pi launcher reuses, secures and recreates the root without deleting task sockets', (t) => {
  const {root, run} = fixture(t);
  mkdirSync(root);
  chmodSync(root, 0o755);
  const retained = join(root, 'active-task');
  writeFileSync(retained, 'keep');
  for (let i = 0; i < 2; i++) {
    const result = run();
    assert.equal(result.status, 0, result.stderr);
    assert.equal(statSync(root).mode & 0o777, 0o700);
    assert.equal(readFileSync(retained, 'utf8'), 'keep');
  }
  rmSync(root, {recursive: true});
  const result = run();
  assert.equal(result.status, 0, result.stderr);
  assert.equal(statSync(root).mode & 0o777, 0o700);
});

test('Pi launcher exports a portable fallback for missing or empty TMPDIR', (t) => {
  const {run, script} = fixture(t);
  // Observe setup without touching the real shared /tmp/pi-sockets directory.
  script('mkdir', 'printf "%s\\0" "$TMPDIR" "$@"\nexit 97\n');
  for (const TMPDIR of [undefined, '']) {
    const result = run({TMPDIR});
    assert.equal(result.status, 1, result.stderr);
    assert.deepEqual(result.stdout.split('\0'), [
      '/tmp',
      '-p',
      '/tmp/pi-sockets',
      '',
    ]);
  }
});

test('Pi launcher rejects invalid temporary directories', (t) => {
  const {temp, run} = fixture(t);
  for (const TMPDIR of ['relative/path', join(temp, 'missing')]) {
    const result = run({TMPDIR});
    assert.notEqual(result.status, 0);
    assert.equal(result.stdout, '');
    assert.match(result.stderr, /existing absolute directory/);
  }
});

test('Pi launcher rejects symlinked socket roots without changing their targets', (t) => {
  const {root, temp, run} = fixture(t);
  const target = join(temp, 'other');
  mkdirSync(target);
  chmodSync(target, 0o755);
  symlinkSync(target, root);
  const result = run();
  assert.notEqual(result.status, 0);
  assert.equal(result.stdout, '');
  assert.match(result.stderr, /not a symlink/);
  assert.equal(statSync(target).mode & 0o777, 0o755);
});

test('Pi launcher aborts before nono if root creation or chmod fails', (t) => {
  const {root, run, script} = fixture(t);
  writeFileSync(root, 'not a directory');
  let result = run();
  assert.notEqual(result.status, 0);
  assert.equal(result.stdout, '');
  assert.equal(readFileSync(root, 'utf8'), 'not a directory');
  rmSync(root);
  script('chmod', 'exit 1\n');
  result = run();
  assert.notEqual(result.status, 0);
  assert.equal(result.stdout, '');
});

test('Pi launcher leaves non-Darwin launches alone', (t) => {
  const {root, run} = fixture(t);
  const result = run({FIXTURE_OS: 'Linux'}, ['hello world']);
  assert.equal(result.status, 0, result.stderr);
  assert.deepEqual(result.stdout.split('\0'), [
    'pi',
    launcher,
    'hello world',
    '',
  ]);
  assert.equal(existsSync(root), false);
});

// Opt in on a trusted macOS host. No credentials or remote services are used.
test('nono permits per-task socket IPC but denies sockets outside the root', {
  skip: process.platform !== 'darwin' ||
    process.env.NONO_SUBAGENT_INTEGRATION !== '1',
  timeout: 30_000,
}, (t) => {
  const {temp, root, run} = fixture(t);
  const setup = run();
  assert.equal(setup.status, 0, setup.stderr);
  const source = renderFixtureProfile();
  const fullProfilePath = join(temp, 'full.jsonc');
  writeFileSync(fullProfilePath, source);
  const validation = spawnSync(
    'nono',
    ['profile', 'validate', fullProfilePath],
    {
      encoding: 'utf8',
      timeout: 10_000,
    },
  );
  assert.equal(validation.status, 0, validation.stderr);
  const profile = JSON.parse(stripJsoncLineComments(source));
  const profilePath = join(temp, 'socket.json');
  // Keep the real root/grant/environment contract, without credential routes
  // or unrelated user-specific filesystem grants from the full profile.
  writeFileSync(
    profilePath,
    JSON.stringify({
      extends: profile.extends,
      groups: profile.groups,
      environment: profile.environment,
      filesystem: {
        read: [dirname(process.execPath)],
        unix_socket_subtree_bind: profile.filesystem.unix_socket_subtree_bind,
      },
    }),
  );
  const probe = `
    const assert = require('node:assert/strict');
    const {mkdtempSync, rmSync} = require('node:fs');
    const {createServer, createConnection} = require('node:net');
    const {join} = require('node:path');
    async function main() {
      const root = process.env.PI_SUBAGENT_SOCKET_ROOT;
      assert.equal(root, join(process.env.TMPDIR, 'pi-sockets'));
      const task = mkdtempSync(join(root, 't-'));
      const socket = join(task, 's');
      assert.ok(Buffer.byteLength(socket) < 104);
      const server = createServer(peer => peer.end('ok'));
      try {
        await new Promise((resolve, reject) => {
          server.once('error', reject);
          server.listen(socket, resolve);
        });
        await new Promise((resolve, reject) => {
          const client = createConnection(socket);
          let data = '';
          client.on('error', reject);
          client.on('data', chunk => data += chunk);
          client.on('end', () => { assert.equal(data, 'ok'); resolve(); });
        });
      } finally {
        await new Promise(resolve => server.close(resolve));
        rmSync(task, {recursive: true, force: true});
      }
      const denied = createServer();
      await new Promise((resolve, reject) => {
        denied.once('error', error => {
          assert.equal(error.code, 'EPERM');
          resolve();
        });
        denied.listen(join(process.env.TMPDIR, 'outside.sock'), () => {
          denied.close();
          reject(new Error('unexpected socket permission outside root'));
        });
      });
      console.log('socket IPC allowed inside root; denied outside');
    }
    main().catch(error => { console.error(error); process.exitCode = 1; });
  `;
  const result = spawnSync('nono', [
    'run',
    '--profile',
    profilePath,
    '--block-net',
    '--no-audit',
    '--no-rollback',
    '--no-diagnostics',
    '--',
    process.execPath,
    '-e',
    probe,
  ], {
    env: {...process.env, TMPDIR: temp},
    encoding: 'utf8',
    timeout: 15_000,
  });
  assert.equal(result.status, 0, result.stderr + result.stdout);
  assert.match(result.stdout, /socket IPC allowed inside root; denied outside/);
  assert.equal(statSync(root).mode & 0o777, 0o700);
});

test('Pi profile exports the short socket root and grants only its subtree', () => {
  for (const metadata of [null, undefined]) {
    const profile = JSON.parse(
      stripJsoncLineComments(renderFixtureProfile(metadata)),
    );
    assert.equal(
      profile.environment.set_vars.PI_SUBAGENT_SOCKET_ROOT,
      '$TMPDIR/pi-sockets',
    );
    assert.deepEqual(profile.filesystem.unix_socket_subtree_bind, [
      '$TMPDIR/pi-sockets',
    ]);
    assert.equal(
      profile.environment.set_vars.XDG_STATE_HOME,
      '$TMPDIR/nono-pi/state',
    );
  }
});
