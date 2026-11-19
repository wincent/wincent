import * as assert from 'node:assert/strict';
import {execFileSync, spawnSync} from 'node:child_process';
import {
  existsSync,
  mkdirSync,
  mkdtempSync,
  readFileSync,
  realpathSync,
  renameSync,
  rmSync,
  statSync,
  symlinkSync,
  writeFileSync,
} from 'node:fs';
import {tmpdir} from 'node:os';
import {dirname, join} from 'node:path';
import {test} from 'node:test';
import {fileURLToPath} from 'node:url';

import {generationFixture} from './nono-generation-fixture.ts';

const helper = fileURLToPath(
  new URL('../../files/.zsh/bin/github-proxy-layer', import.meta.url),
);
const accounts = 'github.com=normal,ddoghq=managed_account';

function checkout(
  t: {after: (fn: () => void) => void},
  hostEnv?: NodeJS.ProcessEnv,
) {
  const home = mkdtempSync(join(tmpdir(), 'github-checkout-'));
  t.after(() => rmSync(home, {recursive: true, force: true}));
  const repo = join(home, 'worktree');
  const env = {HOME: home, PATH: process.env.PATH, ...hostEnv};
  const git = (...args: string[]) =>
    execFileSync('/usr/bin/git', ['-C', repo, ...args], {env});
  mkdirSync(repo);
  git('init', '-q');
  const runAt = (
    dir: string,
    extra: NodeJS.ProcessEnv = {},
    ...args: string[]
  ) =>
    spawnSync(helper, [...args, dir], {
      env: {...env, NONO_GITHUB_SSH_ACCOUNTS: accounts, ...extra},
      encoding: 'utf8',
    });
  const run = (extra: NodeJS.ProcessEnv = {}, ...args: string[]) =>
    runAt(repo, extra, ...args);
  return {git, run, runAt, repo};
}

function binding(layer: string, otherSpellings: string[] = []) {
  const data = JSON.parse(layer);
  const [name] = data.network.credentials;
  const route = data.network.custom_credentials[name];
  const policy = route.endpoint_policy;
  assert.equal(policy.default.decision, 'deny');
  assert.equal(route.upstream, 'https://api.github.com');
  assert.equal(route.env_var, 'GITHUB_TOKEN');
  assert.equal(route.credential_key, `cmd://${name}`);
  const [repo] = policy.allow.map(({path}: {path: string}) => path);
  assert.deepEqual(
    policy.allow,
    [repo, ...otherSpellings].flatMap((base) =>
      ['', '/issues', '/issues/**', '/pulls', '/pulls/**'].map((suffix) => ({
        method: 'GET',
        path: base + suffix,
      }))
    ),
  );
  const command = data.credential_capture[name].command;
  assert.deepEqual(command.slice(-6, -1), [
    'auth',
    'token',
    '--hostname',
    'github.com',
    '--user',
  ]);
  return [repo, command.at(-1)];
}

test('GitHub routing uses raw fetch URLs regardless of the remote name', async (t) => {
  const {env} = await generationFixture(t);
  const {git, run} = checkout(t, env);
  git('remote', 'add', 'origin', 'git@elsewhere.test:public/mirror.git');
  git('remote', 'set-url', '--push', 'origin', 'git@ddoghq:other/fork.git');
  git('remote', 'add', 'up.stream', 'git@github.com:DataDog/trajectory.git');
  git(
    'remote',
    'add',
    'duplicate',
    'ssh://git@github.com/datadog/trajectory.git',
  );
  git('config', 'url.git@ddoghq:.insteadOf', 'git@github.com:');
  const normal = run({GIT_DIR: '/wrong-dir'});
  assert.equal(normal.status, 0, normal.stderr);
  assert.deepEqual(binding(normal.stdout, ['/repos/datadog/trajectory']), [
    '/repos/DataDog/trajectory',
    'normal',
  ]);
  git('remote', 'set-url', 'up.stream', 'git@ddoghq:ddoghq/web-ui.git');
  git('remote', 'remove', 'duplicate');
  const changed = run();
  assert.notEqual(changed.status, 0);
  assert.equal(changed.stdout, '');
  assert.match(changed.stderr, /GitHub binding changed/);
  assert.equal(run({}, '--approve', 'ddoghq/web-ui@managed_account').status, 0);
  const managed = run();
  assert.equal(managed.status, 0, managed.stderr);
  assert.deepEqual(binding(managed.stdout), [
    '/repos/ddoghq/web-ui',
    'managed_account',
  ]);
  const path = run({}, '--file').stdout.trim();
  assert.equal(statSync(path).mode & 0o777, 0o600);
  assert.deepEqual(
    binding(readFileSync(path, 'utf8')),
    binding(managed.stdout),
  );
  assert.equal(run({}, '--file').stdout.trim(), path);
});

test('GitHub routing is opt-in and does not guess between conflicting remotes', (t) => {
  const {git, run} = checkout(t);
  git('remote', 'add', 'upstream', 'git@github.com:owner/repo.git');
  git('remote', 'add', 'fork', 'git@ddoghq:owner/repo.git');
  for (const config of ['', accounts]) {
    const result = run({NONO_GITHUB_SSH_ACCOUNTS: config});
    assert.equal(result.status, 0, result.stderr);
    assert.equal(result.stdout, '');
    assert.equal(/ambiguous/.test(result.stderr), Boolean(config));
  }
  const fork = run({NONO_GITHUB_REMOTE: 'fork'});
  assert.equal(fork.status, 0, fork.stderr);
  assert.deepEqual(binding(fork.stdout), [
    '/repos/owner/repo',
    'managed_account',
  ]);
  assert.notEqual(run({NONO_GITHUB_REMOTE: 'missing'}).status, 0);
  git('remote', 'set-url', 'fork', 'git@ddoghq:elsewhere/other.git');
  assert.match(run().stderr, /ambiguous/);
  git('remote', 'remove', 'upstream');
  git('remote', 'set-url', 'fork', 'git@ddoghq:elsewhere/**');
  assert.equal(run().stdout, '');
});

test('only the first URL of each remote counts, including managed user forks', (t) => {
  const {git, run} = checkout(t);
  git('remote', 'add', 'mirror', 'git@elsewhere.test:archive/project.git');
  git(
    'remote',
    'set-url',
    '--add',
    'mirror',
    'git@github.com:Other/archive.git',
  );
  git('remote', 'add', 'fork', 'git@ddoghq:developer_company/project.git');
  git('remote', 'set-url', '--add', 'fork', 'git@github.com:Other/project.git');
  assert.deepEqual(binding(run().stdout), [
    '/repos/developer_company/project',
    'managed_account',
  ]);
  assert.notEqual(run({NONO_GITHUB_REMOTE: 'mirror'}).status, 0);
});

test('local remote eligibility respects the first raw URL in global config', (t) => {
  const {git, run} = checkout(t);
  git(
    'config',
    '--global',
    'remote.shadowed.url',
    'git@outside.test:archive/project.git',
  );
  git(
    'config',
    '--global',
    'remote.work.url',
    'git@ddoghq:dev_company/project.git',
  );
  git(
    'config',
    '--global',
    'remote.unrelated.url',
    'git@github.com:elsewhere/fork.git',
  );
  git('remote', 'add', 'local', 'git@mirror.test:other/repo.git');
  git(
    'config',
    '--local',
    'remote.shadowed.url',
    'git@github.com:other/project.git',
  );
  git(
    'config',
    '--local',
    'remote.work.url',
    'git@github.com:other/project.git',
  );
  assert.deepEqual(binding(run().stdout), [
    '/repos/dev_company/project',
    'managed_account',
  ]);
  assert.notEqual(run({NONO_GITHUB_REMOTE: 'shadowed'}).status, 0);
});

test('renaming an explicitly selected remote pins its new name', (t) => {
  const {git, run} = checkout(t);
  git('remote', 'add', 'old', 'git@github.com:owner/repo.git');
  git('remote', 'add', 'other', 'git@ddoghq:owner/fork.git');
  assert.equal(run({NONO_GITHUB_REMOTE: 'old'}).status, 0);
  git('remote', 'rename', 'old', 'renamed');
  const env = {NONO_GITHUB_REMOTE: 'renamed'};
  assert.deepEqual(binding(run(env).stdout), ['/repos/owner/repo', 'normal']);
  git('remote', 'set-url', 'renamed', 'git@ddoghq:owner/fork.git');
  assert.match(run(env).stderr, /binding changed/);
});

test('drift through a Git include needs an exact host approval, also from a subdirectory', (t) => {
  const {git, repo, run, runAt} = checkout(t);
  const included = join(repo, 'remotes.config');
  git('config', 'include.path', included);
  git(
    'config',
    '--file',
    included,
    'remote.github.url',
    'git@github.com:owner/one.git',
  );
  const sub = join(repo, 'subdir');
  mkdirSync(sub);
  assert.deepEqual(binding(runAt(sub).stdout), ['/repos/owner/one', 'normal']);
  git(
    'config',
    '--file',
    included,
    'remote.github.url',
    'git@github.com:owner/two.git',
  );
  for (
    const result of [
      run(),
      runAt(sub),
      run({}, '--approve', 'owner/one@normal'),
    ]
  ) {
    assert.notEqual(result.status, 0);
    assert.equal(result.stdout, '');
  }
  // A new .git marker in the writable subtree cannot create a fresh trust record.
  git('-C', sub, 'init', '-q');
  git('-C', sub, 'remote', 'add', 'github', 'git@github.com:other/nested.git');
  assert.match(runAt(sub).stderr, /binding changed/);
  assert.equal(run({}, '--approve', 'owner/two@normal').status, 0);
  assert.deepEqual(binding(run().stdout), ['/repos/owner/two', 'normal']);
});

test('checkout path aliases cannot reset a binding; case-distinct directories remain independent', (t) => {
  const {repo, git, run, runAt} = checkout(t);
  const alternate = join(dirname(repo), 'WORKTREE');
  git('remote', 'add', 'github', 'git@github.com:owner/one.git');
  assert.equal(run().status, 0);
  git('remote', 'set-url', 'github', 'git@github.com:owner/two.git');
  if (existsSync(alternate)) {
    assert.equal(statSync(alternate).ino, statSync(repo).ino);
    assert.match(runAt(alternate).stderr, /binding changed/);
    const original = repo + '-old';
    renameSync(repo, original);
    mkdirSync(alternate);
    git('init', '-q');
    git('remote', 'add', 'github', 'git@github.com:owner/replacement.git');
    assert.notEqual(statSync(original).ino, statSync(alternate).ino);
    assert.match(runAt(alternate).stderr, /binding changed/);
  } else {
    mkdirSync(alternate);
    git('-C', alternate, 'init', '-q');
    git(
      '-C',
      alternate,
      'remote',
      'add',
      'github',
      'git@github.com:owner/two.git',
    );
    assert.deepEqual(binding(runAt(alternate).stdout), [
      '/repos/owner/two',
      'normal',
    ]);
  }
});

test('previously unscoped checkout cannot silently acquire a first credential', (t) => {
  const {git, run} = checkout(t);
  assert.equal(run().stdout, '');
  git('remote', 'add', 'origin', 'git@ddoghq:org/repo.git');
  assert.match(run().stderr, /binding changed/);
  assert.match(run({NONO_GITHUB_REMOTE: 'origin'}).stderr, /binding changed/);
});

test('native and standalone refuse inherited GitHub capture and route collisions', async (t) => {
  const fixture = await generationFixture(t);
  const {git, run} = checkout(t, fixture.env);
  git('remote', 'add', 'origin', 'git@github.com:owner/repo.git');
  const layer = run().stdout;
  writeFileSync(join(fixture.profiles, 'pi.jsonc'), '{"extends":"private"}');
  for (
    const config of [{
      credential_capture: {github_checkout: {command: ['old-capture']}},
    }, {
      network: {
        custom_credentials: {github_checkout: {credential_key: 'cmd://other'}},
      },
    }, {
      network: {
        custom_credentials: {
          private_route: {credential_key: 'cmd://github_checkout'},
        },
      },
    }, {
      platform_overrides: {
        [process.platform === 'darwin' ? 'macos' : 'linux']: {
          credential_capture: {github_checkout: {command: ['old-capture']}},
        },
      },
    }, {
      command_policies: {
        credentials: {private_route: {credential_key: 'cmd://github_checkout'}},
      },
    }]
  ) {
    writeFileSync(
      join(fixture.profiles, 'private.json'),
      JSON.stringify(config),
    );
    const native = run({}, '--file');
    const standalone = await fixture.run([
      '--github-layer',
      layer,
      'acquire',
      String(process.pid),
    ]);
    for (const result of [native, standalone]) {
      assert.notEqual(result.status, 0);
      assert.match(result.stderr, /already uses github_checkout/);
      assert.equal(result.stdout, '');
    }
    // No GitHub overlay: existing private profiles can still be used.
    await fixture.acquire();
  }
});

test('an authored checkout-base and null optional policy fields work in both overlays', async (t) => {
  const fixture = await generationFixture(t);
  const {git, run} = checkout(t, fixture.env);
  git('remote', 'add', 'origin', 'git@github.com:owner/repo.git');
  const parentName = 'checkout-base';
  writeFileSync(
    join(fixture.profiles, parentName + '.json'),
    JSON.stringify({
      platform_overrides: null,
      network: {credentials: null},
    }),
  );
  writeFileSync(
    join(fixture.profiles, 'pi.jsonc'),
    JSON.stringify({
      extends: parentName,
      network: {credentials: null},
    }),
  );
  const native = run({}, '--file');
  assert.equal(native.status, 0, native.stderr);
  const path = native.stdout.trim();
  const generatedName = JSON.parse(readFileSync(path, 'utf8')).extends;
  assert.notEqual(generatedName, parentName);
  assert.equal(
    JSON.parse(
      readFileSync(join(dirname(path), generatedName + '.json'), 'utf8'),
    ).extends,
    parentName,
  );

  const standalone = await fixture.run([
    '--github-layer',
    run().stdout,
    'acquire',
    String(process.pid),
  ]);
  assert.equal(standalone.status, 0, standalone.stderr);
  const frozen = join(
    fixture.state,
    'generations',
    standalone.stdout.trim(),
    'profiles/pi.jsonc',
  );
  assert.deepEqual(binding(readFileSync(frozen, 'utf8')), [
    '/repos/owner/repo',
    'normal',
  ]);
});

test('native launches reject user policy reached via an unredirectable built-in parent', async (t) => {
  const fixture = await generationFixture(t);
  const {git, run} = checkout(t, fixture.env);
  git('remote', 'add', 'origin', 'git@github.com:owner/repo.git');
  writeFileSync(
    join(fixture.profiles, 'pi.jsonc'),
    '{"extends":"linux-host-compat"}',
  );
  writeFileSync(join(fixture.profiles, 'default.jsonc'), '{}');
  writeFileSync(
    join(fixture.bin, 'nono'),
    `#!/bin/sh
[ "$1 $2" = 'profile list' ] || exit 90
printf '%s\\n' '[{"name":"linux-host-compat","source":"built-in","extends":["default"]}]'
`,
  );
  const result = run({}, '--file');
  assert.notEqual(result.status, 0);
  assert.match(
    result.stderr,
    /cannot freeze user profile 'default' inherited via a built-in/,
  );
  assert.equal(result.stdout, '');
});

test('native snapshots redirect a self-sibling lookup to its frozen global parent', async (t) => {
  const fixture = await generationFixture(t);
  const {git, run} = checkout(t, fixture.env);
  git('remote', 'add', 'origin', 'git@github.com:owner/repo.git');
  const source = join(fixture.home, 'base.json');
  writeFileSync(source, '{"extends":["base"]}');
  const pi = join(fixture.profiles, 'pi.jsonc');
  rmSync(pi);
  symlinkSync(source, pi);
  const global = join(fixture.profiles, 'base.jsonc');
  writeFileSync(global, '{"description":"original"}');
  const result = run({}, '--file');
  assert.equal(result.status, 0, result.stderr);
  const layer = result.stdout.trim();
  const parentName = JSON.parse(readFileSync(layer, 'utf8')).extends;
  const frozen = realpathSync(join(dirname(layer), parentName + '.json'));
  const [name] = JSON.parse(readFileSync(frozen, 'utf8')).extends;
  assert.notEqual(name, 'base');
  rmSync(global);
  assert.match(
    readFileSync(join(dirname(frozen), name + '.json'), 'utf8'),
    /original/,
  );
});

test('native launches consume the checked base bytes, including inherited private captures', async (t) => {
  const fixture = await generationFixture(t);
  const {git, run} = checkout(t, fixture.env);
  git('remote', 'add', 'origin', 'git@github.com:owner/repo.git');
  const base = join(fixture.profiles, 'pi.jsonc');
  const parent = join(fixture.profiles, 'private.jsonc');
  writeFileSync(base, '{"extends":"private"}');
  writeFileSync(
    parent,
    '{"credential_capture":{"unrelated":{"command":["original"]}}}',
  );
  const result = run({}, '--file');
  assert.equal(result.status, 0, result.stderr);
  const layer = result.stdout.trim();
  const snapshot = dirname(layer);
  const frozenParent = join(snapshot, 'profiles/private.json');
  writeFileSync(
    parent,
    '{"credential_capture":{"github_checkout":{"command":["replacement"]}}}',
  );
  writeFileSync(base, '{"extends":"changed"}');
  const parentName = JSON.parse(readFileSync(layer, 'utf8')).extends;
  assert.match(
    readFileSync(join(snapshot, parentName + '.json'), 'utf8'),
    /private/,
  );
  assert.match(readFileSync(frozenParent, 'utf8'), /original/);
  assert.deepEqual(binding(readFileSync(layer, 'utf8')), [
    '/repos/owner/repo',
    'normal',
  ]);
});

test('GitHub generations snapshot the route and use distinct client passwords', async (t) => {
  const {git, run: resolve} = checkout(t);
  const {state, run, acquire} = await generationFixture(t);
  git('remote', 'add', 'github', 'git@github.com:owner/repo.git');
  const normal = resolve().stdout;
  git('remote', 'set-url', 'github', 'git@ddoghq:owner/repo.git');
  assert.equal(
    resolve({}, '--approve', 'owner/repo@managed_account').status,
    0,
  );
  const managed = resolve().stdout;
  const plain = await acquire();
  async function scoped(layer: string) {
    const result = await run([
      '--github-layer',
      layer,
      'acquire',
      String(process.pid),
    ]);
    assert.equal(result.status, 0, result.stderr);
    return result.stdout.trim();
  }
  const first = await scoped(normal);
  const second = await scoped(managed);
  assert.equal(await scoped(normal), first);
  assert.equal(new Set([plain, first, second]).size, 3);
  assert.equal(
    new Set(
      [plain, first, second].map((id) =>
        readFileSync(join(state, 'generations', id, 'pass'), 'utf8')
      ),
    ).size,
    3,
  );
  for (const [id, layer] of [[first, normal], [second, managed]]) {
    const path = join(state, 'generations', id, 'profiles/pi.jsonc');
    const profile = readFileSync(path, 'utf8');
    assert.deepEqual(binding(profile), binding(layer));
    assert.equal(JSON.parse(profile).version, 1);
    const env = await run(['--generation', id, 'env']);
    assert.match(env.stdout, /unset GH_TOKEN GITHUB_TOKEN\n/);
    assert.match(env.stdout, /export GITHUB_TOKEN=proxied\n/);
  }
  const env = await run(['--generation', plain, 'env']);
  assert.doesNotMatch(env.stdout, /GITHUB_TOKEN/);
});
