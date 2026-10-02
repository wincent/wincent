import * as assert from 'node:assert/strict';
import {spawnSync} from 'node:child_process';
import {
  mkdirSync,
  mkdtempSync,
  readFileSync,
  rmSync,
  symlinkSync,
  writeFileSync,
} from 'node:fs';
import {tmpdir} from 'node:os';
import {join} from 'node:path';
import {type TestContext, test} from 'node:test';

const template = readFileSync(
  new URL('../../templates/.zsh/bin/sb.erb', import.meta.url),
  'utf8',
);
const functions = [['bootstrap_vm() {', '# Allow public-key access'], [
  'cmd_create() {',
  'cmd_ssh() {',
], ['cmd_reset() {', 'cmd_stop() {']].map(([start, end]) =>
  template.slice(template.indexOf(start), template.indexOf(end))
).join('\n');

function fixture(t: TestContext, failHook = false) {
  const home = mkdtempSync(join(tmpdir(), 'sb-lifecycle-'));
  t.after(() => rmSync(home, {recursive: true, force: true}));
  const checkout = join(home, 'code/wincent/aspects/dotfiles/files/.pi');
  mkdirSync(join(checkout, 'agent'), {recursive: true});
  symlinkSync(checkout, join(home, '.pi'), 'dir');
  const settings = join(home, '.pi/agent/settings.json');
  writeFileSync(settings, '{"old":true}\n');
  const log = join(home, 'calls');
  function run(command: 'create' | 'reset') {
    return spawnSync('/bin/bash', [
      '-c',
      `set -euo pipefail
${functions}
VM_NAME=fixture
PROJECT_ROOT="$HOME/code/wincent"
SB_VM_IMAGE=registry.example/base:latest
SB_VM_CPU=4
SB_VM_MEMORY=8192
VM_USER=fixture
USE_REGISTRY=false
record() { printf '%s\\n' "$1" >> "$CALLS"; }
tart() { :; }
vm_exists() { return 1; }
wait_for_ip() { printf '127.0.0.1\\n'; }
wait_for_ssh() { record wait; }
install_ssh_key() { record key; }
git() { printf 'fixture\\n'; }
sb_ssh() { if [[ "$2" == hostname ]]; then printf 'fixture\\n'; else record identity; fi; }
init_repo() { record init; }
configure_claude() { record claude; }
cmd_destroy() { record destroy; }
cmd_inject() {
  [[ "$1" == --force ]]
  record inject
  # Reproduce cleanup of ignored generated files behind the ~/.pi symlink.
  rm -f "$SETTINGS"
}
sb_provision() {
  [[ "$1" == 127.0.0.1 ]]
  record hook
  ${
        failHook
          ? 'return 27'
          : 'printf \'{"enabledModels":["fixture/*"]}\\n\' > "$SETTINGS"'
      }
}
cmd_${command}
`,
    ], {
      encoding: 'utf8',
      env: {HOME: home, PATH: process.env.PATH, CALLS: log, SETTINGS: settings},
    });
  }
  return {settings, log, run};
}

for (const command of ['create', 'reset'] as const) {
  test(`sb ${command} applies custom settings after injection cleans the linked dotfiles tree`, (t) => {
    const {settings, log, run} = fixture(t);
    const result = run(command);
    assert.equal(result.status, 0, result.stderr);
    assert.deepEqual(readFileSync(log, 'utf8').trim().split('\n'), [
      ...(command === 'reset' ? ['destroy'] : []),
      'wait',
      'key',
      'identity',
      'init',
      'claude',
      'inject',
      'hook',
    ]);
    assert.deepEqual(JSON.parse(readFileSync(settings, 'utf8')), {
      enabledModels: ['fixture/*'],
    });
    assert.match(result.stdout, /VM 'fixture' is ready/);
  });
}

test('a failed post-injection hook aborts creation before reporting readiness', (t) => {
  const {log, run} = fixture(t, true);
  const result = run('create');
  assert.equal(result.status, 27);
  assert.match(readFileSync(log, 'utf8'), /inject\nhook\n$/);
  assert.doesNotMatch(result.stdout, /is ready/);
});
