import * as assert from 'node:assert/strict';
import {execFileSync, spawnSync} from 'node:child_process';
import {mkdirSync, mkdtempSync, readFileSync, rmSync, statSync} from 'node:fs';
import {tmpdir} from 'node:os';
import {join} from 'node:path';
import {test} from 'node:test';
import {fileURLToPath} from 'node:url';

import {generationFixture} from './nono-generation-fixture.ts';

const helper = fileURLToPath(
  new URL('../../files/.zsh/bin/github-proxy-layer', import.meta.url),
);
const accounts = 'github.com=normal,ddoghq=managed_account';

function checkout(t: {after: (fn: () => void) => void}) {
  const home = mkdtempSync(join(tmpdir(), 'github-checkout-'));
  t.after(() => rmSync(home, {recursive: true, force: true}));
  const repo = join(home, 'worktree');
  const env = {HOME: home, PATH: process.env.PATH};
  const git = (...args: string[]) =>
    execFileSync('/usr/bin/git', ['-C', repo, ...args], {env});
  mkdirSync(repo);
  git('init', '-q');
  const run = (extra: NodeJS.ProcessEnv = {}, ...args: string[]) =>
    spawnSync(helper, [...args, repo], {
      env: {...env, NONO_GITHUB_SSH_ACCOUNTS: accounts, ...extra},
      encoding: 'utf8',
    });
  return {git, run};
}

function binding(layer: string) {
  const data = JSON.parse(layer);
  const route = data.network.custom_credentials.github_checkout;
  const policy = route.endpoint_policy;
  assert.equal(policy.default.decision, 'deny');
  assert.equal(route.upstream, 'https://api.github.com');
  assert.equal(route.env_var, 'GITHUB_TOKEN');
  assert.equal(route.credential_key, 'cmd://github_checkout');
  const [repo] = policy.allow.map(({path}: {path: string}) => path);
  assert.deepEqual(
    policy.allow,
    ['', '/issues', '/issues/**', '/pulls', '/pulls/**'].map((suffix) => ({
      method: 'GET',
      path: repo + suffix,
    })),
  );
  const command = data.credential_capture.github_checkout.command;
  assert.deepEqual(command.slice(-6, -1), [
    'auth',
    'token',
    '--hostname',
    'github.com',
    '--user',
  ]);
  return [repo, command.at(-1)];
}

test('GitHub routing uses raw fetch URLs regardless of the remote name', (t) => {
  const {git, run} = checkout(t);
  git('remote', 'add', 'origin', 'git@elsewhere.test:public/mirror.git');
  git('remote', 'set-url', '--push', 'origin', 'git@ddoghq:other/fork.git');
  git('remote', 'add', 'up.stream', 'git@github.com:DataDog/trajectory.git');
  git(
    'remote',
    'add',
    'duplicate',
    'ssh://git@github.com/DataDog/trajectory.git',
  );
  git('config', 'url.git@ddoghq:.insteadOf', 'git@github.com:');
  const normal = run({GIT_DIR: '/wrong-dir'});
  assert.equal(normal.status, 0, normal.stderr);
  assert.deepEqual(binding(normal.stdout), [
    '/repos/DataDog/trajectory',
    'normal',
  ]);
  git('remote', 'set-url', 'up.stream', 'git@ddoghq:ddoghq/web-ui.git');
  git('remote', 'remove', 'duplicate');
  const managed = run();
  assert.equal(managed.status, 0, managed.stderr);
  assert.deepEqual(binding(managed.stdout), [
    '/repos/ddoghq/web-ui',
    'managed_account',
  ]);
  const path = run({}, '--file').stdout.trim();
  assert.equal(statSync(path).mode & 0o777, 0o600);
  assert.equal(readFileSync(path, 'utf8'), managed.stdout.trim());
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

test('GitHub generations snapshot the route and use distinct client passwords', async (t) => {
  const {git, run: resolve} = checkout(t);
  const {state, run, acquire} = await generationFixture(t);
  git('remote', 'add', 'github', 'git@github.com:owner/repo.git');
  const normal = resolve().stdout;
  git('remote', 'set-url', 'github', 'git@ddoghq:owner/repo.git');
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
