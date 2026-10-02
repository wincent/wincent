import * as assert from 'node:assert/strict';
import {spawnSync} from 'node:child_process';
import {
  chmodSync,
  mkdirSync,
  mkdtempSync,
  readFileSync,
  realpathSync,
  rmSync,
  writeFileSync,
} from 'node:fs';
import {tmpdir} from 'node:os';
import {dirname, join} from 'node:path';
import {type TestContext, test} from 'node:test';

const template = readFileSync(
  new URL('../../templates/.zsh/bin/sb.erb', import.meta.url),
  'utf8',
);
// Execute the actual loader/defaults/derived values and provisioning function,
// but stub all VM and Git operations. No Tart, SSH, or real configuration.
const loader = template.slice(
  0,
  template.indexOf('# --- Internal helpers ---'),
);
const provision = template.slice(
  template.indexOf('provision() {'),
  template.indexOf('# Allow public-key access'),
);
const hook = (name: string) =>
  `sb_provision() { printf 'HOOK=${name}:%s\\n' "$1"; }\n`;
const baseConfig = `
type sb_ssh >/dev/null
type sb_scp >/dev/null
SB_VM_CPU=6
SB_VM_MEMORY=16384
SB_REPO_SUBDIR=base-repos
SB_BRANCHES=(base extra)
${hook('base')}`;

function fixture(t: TestContext) {
  const home = realpathSync(mkdtempSync(join(tmpdir(), 'sb-config-test-')));
  t.after(() => rmSync(home, {recursive: true, force: true}));
  const project = join(home, 'code/project');
  mkdirSync(join(project, '.git'), {recursive: true});
  const base = join(home, 'base config');
  const local = join(project, '.sandboxrc');
  const roots = [join(home, 'config one'), join(home, 'config two')];
  const external = roots.map((root) => join(root, 'code/project/sandboxrc'));
  function write(path: string, content: string) {
    mkdirSync(dirname(path), {recursive: true});
    writeFileSync(path, content);
  }
  function run(basePath?: string, create = true) {
    return spawnSync('/bin/bash', [
      '-c',
      `${loader}
${provision}
install_ssh_key() { :; }
git() { printf 'fixture\\n'; }
sb_ssh() { printf 'fixture\\n'; }
printf 'CPU=%s\\nMEMORY=%s\\nBRANCHES=%s\\nREPO=%s\\n' \\
  "$SB_VM_CPU" "$SB_VM_MEMORY" "\${SB_BRANCHES[*]}" "$VM_REPO_PATH"
${create ? 'provision 127.0.0.1' : ''}
`,
    ], {
      cwd: project,
      encoding: 'utf8',
      env: {
        HOME: home,
        PATH: process.env.PATH,
        SB_CONFIG_PATH: roots.join(':'),
        ...(basePath === undefined ? {} : {SB_BASE_CONFIG: basePath}),
      },
    });
  }
  return {home, base, local, external, write, run};
}

function succeeds(result: ReturnType<ReturnType<typeof fixture>['run']>) {
  assert.equal(result.status, 0, result.stderr);
  return result.stdout;
}

function onlyHook(output: string, name: string) {
  assert.deepEqual(output.match(/^HOOK=.*$/gm), [`HOOK=${name}:127.0.0.1`]);
}

test('unset or empty base config preserves defaults without discovering private files', (t) => {
  const {home, base, write, run} = fixture(t);
  write(base, 'exit 19');
  write(join(home, '.config/sb/sandboxrc'), 'exit 19');
  for (const path of [undefined, '']) {
    const output = succeeds(run(path));
    assert.match(output, /^CPU=4$/m);
    assert.match(output, /^MEMORY=8192$/m);
    assert.match(output, /^BRANCHES=main$/m);
    assert.match(output, /^REPO=\/home\/admin\/code\/project$/m);
    assert.doesNotMatch(output, /HOOK=/);
  }
});

test('base config can use helpers and supplies defaults before derived paths', (t) => {
  const {base, write, run} = fixture(t);
  write(base, baseConfig);
  const output = succeeds(run(base));
  assert.match(output, /^CPU=6$/m);
  assert.match(output, /^MEMORY=16384$/m);
  assert.match(output, /^BRANCHES=base extra$/m);
  assert.match(output, /^REPO=\/home\/admin\/base-repos\/project$/m);
  onlyHook(output, 'base');
  assert.doesNotMatch(succeeds(run(base, false)), /HOOK=/);
});

test('project settings override defaults and can append arrays while inheriting the hook', (t) => {
  const {base, local, write, run} = fixture(t);
  write(base, baseConfig);
  write(
    local,
    'SB_VM_CPU=8\nSB_REPO_SUBDIR=project-repos\nSB_BRANCHES+=(local)\n',
  );
  const output = succeeds(run(base));
  assert.match(output, /^CPU=8$/m);
  assert.match(output, /^MEMORY=16384$/m);
  assert.match(output, /^BRANCHES=base extra local$/m);
  assert.match(output, /^REPO=\/home\/admin\/project-repos\/project$/m);
  onlyHook(output, 'base');
});

test('local config replaces the hook and arrays, taking precedence over external configs', (t) => {
  const {base, local, external, write, run} = fixture(t);
  write(base, baseConfig);
  for (const path of external) {
    write(path, 'exit 19');
  }
  write(local, `SB_BRANCHES=(local)\n${hook('local')}`);
  for (const basePath of [undefined, base]) {
    const output = succeeds(run(basePath));
    assert.match(output, /^BRANCHES=local$/m);
    onlyHook(output, 'local');
  }
});

test('first matching external config overrides base values and optionally its hook', (t) => {
  const {base, external, write, run} = fixture(t);
  write(base, baseConfig);
  write(external[1], 'exit 19');
  for (const override of [false, true]) {
    write(external[0], `SB_VM_CPU=10\n${override ? hook('external') : ''}`);
    const output = succeeds(run(base));
    assert.match(output, /^CPU=10$/m);
    onlyHook(output, override ? 'external' : 'base');
  }
});

test('project config can explicitly disable the inherited hook', (t) => {
  const {base, local, write, run} = fixture(t);
  write(base, baseConfig);
  write(local, 'unset -f sb_provision\n');
  assert.doesNotMatch(succeeds(run(base)), /HOOK=/);
});

test('missing files and directories fail before loading project config', (t) => {
  const {home, base, local, write, run} = fixture(t);
  write(local, 'echo PROJECT_LOADED\n');
  for (const path of [base, home]) {
    const result = run(path);
    assert.equal(result.status, 1);
    assert.match(result.stderr, /SB_BASE_CONFIG must name a readable file/);
    assert.equal(result.stdout, '');
  }
});

test(
  'unreadable base config fails clearly',
  {skip: process.getuid?.() === 0},
  (t) => {
    const {base, write, run} = fixture(t);
    write(base, baseConfig);
    chmodSync(base, 0o000);
    const result = run(base);
    assert.equal(result.status, 1);
    assert.match(result.stderr, /SB_BASE_CONFIG must name a readable file/);
    assert.equal(result.stdout, '');
  },
);

test('base syntax and command failures abort instead of silently continuing', (t) => {
  const {base, local, write, run} = fixture(t);
  write(local, 'echo PROJECT_LOADED\n');
  for (const content of ['if then\n', 'false\necho BASE_CONTINUED\n']) {
    write(base, content);
    const result = run(base);
    assert.notEqual(result.status, 0);
    assert.equal(result.stdout, '');
  }
});
