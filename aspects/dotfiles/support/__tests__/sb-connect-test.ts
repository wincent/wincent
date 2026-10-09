import * as assert from 'node:assert/strict';
import {spawnSync} from 'node:child_process';
import {
  mkdirSync,
  mkdtempSync,
  readFileSync,
  realpathSync,
  rmSync,
  writeFileSync,
} from 'node:fs';
import {tmpdir} from 'node:os';
import {join} from 'node:path';
import {type TestContext, test} from 'node:test';

const template = readFileSync(
  new URL('../../templates/.zsh/bin/sb.erb', import.meta.url),
  'utf8',
);
const loader = template.slice(
  0,
  template.indexOf('# --- Internal helpers ---'),
);
const ssh = template.slice(
  template.indexOf('cmd_ssh() {'),
  template.indexOf('cmd_scp() {'),
);

function fixture(t: TestContext, base = '', local = '') {
  const home = realpathSync(mkdtempSync(join(tmpdir(), 'sb-connect-')));
  t.after(() => rmSync(home, {recursive: true, force: true}));
  const project = join(home, 'project');
  const bin = join(home, 'bin');
  const calls = join(home, 'calls');
  mkdirSync(join(project, '.git'), {recursive: true});
  mkdirSync(bin);
  writeFileSync(calls, '');
  writeFileSync(join(home, 'base'), base);
  if (local) {
    writeFileSync(join(project, '.sandboxrc'), local);
  }
  writeFileSync(
    join(bin, 'ssh'),
    `#!/bin/bash
printf 'session:%s\\n' "$*" >> "$CALLS"
printf 'cwd:%s\\n' "$PWD" >> "$CALLS"
cat
`,
    {mode: 0o755},
  );
  function run(command = 'cmd_ssh', extra = '') {
    const result = spawnSync('/bin/bash', [
      '-c',
      `${loader}
vm_ip() { echo 127.0.0.1; }
setup_nono_proxy_for_vm() {
  cat >/dev/null
  printf 'proxy:%s\\n' "$1" >> "$CALLS"
  SB_NONO_PROXY_PORT=12345
  SB_GUEST_PROXY_PORT=4567
  GUEST_ENV_SCRIPT='export FIXTURE_API_KEY=proxied; '
}
setup_optional_ssh_forwards() {
  cat >/dev/null
  printf 'forwards:%s\\n' "$1" >> "$CALLS"
  MUX_ARGS=()
}
${ssh}
${extra}
${command}
`,
    ], {
      encoding: 'utf8',
      cwd: project,
      input: 'remote stdin payload\n',
      timeout: 10_000,
      env: {
        HOME: home,
        PATH: `${bin}:${process.env.PATH}`,
        CALLS: calls,
        ...(base ? {SB_BASE_CONFIG: join(home, 'base')} : {}),
      },
    });
    return {...result, calls: readFileSync(calls, 'utf8')};
  }
  return {project, run};
}

const baseHook = `sb_before_connect() {
  cat >/dev/null
  type sb_ssh >/dev/null
  type sb_scp >/dev/null
  printf 'base:%s\\n' "$1" >> "$CALLS"
  cd /
  SSH_OPTS=(-o INVALID_HOOK_SETTING=yes)
}
`;

test('without a connect hook, setup preserves stdin for the remote command', (t) => {
  const result = fixture(t).run('cmd_ssh cat');
  assert.equal(result.status, 0, result.stderr);
  assert.equal(result.stdout, 'remote stdin payload\n');
  assert.match(
    result.calls,
    /^proxy:127\.0\.0\.1\nforwards:127\.0\.0\.1\nsession:/,
  );
});

for (
  const [command, extra] of [['cmd_ssh', ''], ['cmd_ssh', "SB_SSH_EXEC=''"], [
    'cmd_ssh cat',
    '',
  ]]
) {
  test(`inherited connect hook runs before setup in isolation: ${command} ${extra}`, (t) => {
    const {project, run} = fixture(t, baseHook, 'sb_provision() { exit 19; }');
    const result = run(command, extra);
    assert.equal(result.status, 0, result.stderr);
    assert.equal(result.stdout, 'remote stdin payload\n');
    assert.match(
      result.calls,
      /^base:127\.0\.0\.1\nproxy:127\.0\.0\.1\nforwards:127\.0\.0\.1\nsession:/,
    );
    assert.ok(result.calls.includes(`cwd:${project}\n`));
    assert.doesNotMatch(result.calls, /INVALID_HOOK_SETTING/);
    assert.match(
      result.calls,
      /export FIXTURE_API_KEY=proxied; export SB_SANDBOX=1\n/,
    );
  });
}

test('project connect hook replaces the base hook', (t) => {
  const result = fixture(
    t,
    baseHook,
    `sb_before_connect() { printf 'local:%s\\n' "$1" >> "$CALLS"; }`,
  ).run();
  assert.equal(result.status, 0, result.stderr);
  assert.match(result.calls, /^local:127\.0\.0\.1\nproxy:/);
  assert.doesNotMatch(result.calls, /base:/);
});

test('project can explicitly disable its inherited connect hook', (t) => {
  const result = fixture(t, baseHook, 'unset -f sb_before_connect').run();
  assert.equal(result.status, 0, result.stderr);
  assert.match(result.calls, /^proxy:/);
  assert.doesNotMatch(result.calls, /base:/);
});

test('an intermediate hook failure aborts before proxy setup or SSH', (t) => {
  const result = fixture(
    t,
    'sb_before_connect() { false; echo SHOULD_NOT_RUN; }',
  ).run();
  assert.notEqual(result.status, 0);
  assert.match(
    result.stderr,
    /before-connect hook failed; refusing to connect/,
  );
  assert.equal(result.stdout, '');
  assert.equal(result.calls, '');
});

test('IP lookup failure never runs a connect hook', (t) => {
  const result = fixture(t, baseHook).run('cmd_ssh', 'vm_ip() { return 1; }');
  assert.notEqual(result.status, 0);
  assert.equal(result.calls, '');
});
