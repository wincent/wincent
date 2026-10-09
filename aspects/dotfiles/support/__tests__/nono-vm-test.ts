import * as assert from 'node:assert/strict';
import {execFile} from 'node:child_process';
import {readFileSync, writeFileSync} from 'node:fs';
import {createServer} from 'node:net';
import {dirname, join} from 'node:path';
import {test} from 'node:test';
import {promisify} from 'node:util';

import {generationFixture, proxyScript} from './nono-generation-fixture.ts';

const exec = promisify(execFile);
const template = readFileSync(
  new URL('../../templates/.zsh/bin/sb.erb', import.meta.url),
  'utf8',
);
const setup = template.slice(
  template.indexOf('setup_nono_proxy_for_vm() {'),
  template.indexOf('# --- Commands ---'),
);
const optional = template.slice(
  template.indexOf('setup_optional_ssh_forwards() {'),
  template.indexOf('# --- Commands ---'),
);
const ssh = template.slice(
  template.indexOf('cmd_ssh() {'),
  template.indexOf('cmd_scp() {'),
);

test('VM setup leases one generation and pins CA, exports and distinct guest port to it', async (t) => {
  const {bin, home, env, acquire, run} = await generationFixture(t);
  const generation = await acquire();
  const port = (await run(['--generation', generation, 'port'])).stdout.trim();
  const calls = join(home, 'calls');
  writeFileSync(
    join(bin, 'nono-proxy'),
    `#!/bin/bash
printf '%s\\n' "$*" >> "$CALLS"
exec "$PROXY_SCRIPT" "$@"
`,
    {mode: 0o755},
  );
  const script = `set -euo pipefail
VM_USER=fixture
sb_ssh() {
  if [[ "$2" == python3* ]]; then echo 4567;
  elif [[ "$2" == 'bash -s'* ]]; then cat >/dev/null; fi
}
sb_scp() { printf '%s\\n' "$*" >> "$CALLS"; }
${setup}
setup_nono_proxy_for_vm 127.0.0.1
printf '%s\\n' "$SB_NONO_PROXY_PORT" "$SB_GUEST_PROXY_PORT" "$GUEST_ENV_SCRIPT"
`;
  const result = await exec('/bin/bash', ['-c', script], {
    env: {...env, CALLS: calls, PROXY_SCRIPT: proxyScript},
  });
  assert.match(result.stdout, new RegExp(`^${port}\\n4567\\n`));
  assert.match(result.stdout, /127\.0\.0\.1:4567/);
  assert.match(
    result.stdout,
    new RegExp(
      `/home/fixture/\\.local/state/nono-proxy/${generation}/ca\\.crt`,
    ),
  );
  const log = readFileSync(calls, 'utf8');
  assert.match(log, /^acquire \d+$/m);
  assert.match(log, new RegExp(`--generation ${generation} ca`));
  assert.match(log, new RegExp(`--generation ${generation} port`));
  assert.match(
    log,
    new RegExp(`--generation ${generation} --guest-port 4567 guest-env`),
  );
});

test('optional forward collisions cannot abort the required proxy tunnel', async (t) => {
  const {home, bin, env} = await generationFixture(t);
  const calls = join(home, 'optional-calls');
  writeFileSync(
    join(bin, 'nono-proxy'),
    '#!/bin/bash\nexec "$PROXY_SCRIPT" "$@"\n',
    {mode: 0o755},
  );
  writeFileSync(
    join(bin, 'ssh'),
    `#!/bin/bash
if [[ "$*" == *'-O forward'* ]]; then
  printf '%s\\n' "$*" >> "$CALLS"
  exit 255 # Simulate an occupied development port or clipper socket.
fi
printf '%s\\n' "$@"
`,
    {mode: 0o755},
  );
  const script = `set -euo pipefail
vm_ip() { echo 127.0.0.1; }
VM_USER=fixture
SSH_OPTS=(-o ControlPath=none)
SB_PORTS=(3000:3000)
SB_SOCKETS=(/host/clipper.sock:/guest/clipper.sock)
SB_SSH_EXEC='exec sh'
setup_nono_proxy_for_vm() {
  SB_NONO_PROXY_GENERATION="$(nono-proxy acquire "$$")"
  SB_NONO_PROXY_PORT=12345
  SB_GUEST_PROXY_PORT=4567
  GUEST_ENV_SCRIPT='export FIXTURE_API_KEY=proxied; '
}
${optional}
${ssh}
cmd_ssh
`;
  const options = {env: {...env, PROXY_SCRIPT: proxyScript, CALLS: calls}};
  const result = await exec('/bin/bash', ['-c', script], options);
  assert.match(result.stdout, /ExitOnForwardFailure=yes/);
  assert.match(result.stdout, /ControlPersist=no/);
  assert.match(result.stdout, /127\.0\.0\.1:4567:127\.0\.0\.1:12345/);
  assert.doesNotMatch(
    result.stdout,
    /3000:localhost:3000|\/guest\/clipper.sock/,
  );
  const hook = result.stdout.match(/LocalCommand=\/bin\/bash (\S+) &/)?.[1];
  assert.ok(hook);
  const server = createServer();
  await new Promise<void>((resolve) =>
    server.listen(join(dirname(hook), 'control'), resolve)
  );
  t.after(() => {
    server.close();
  });
  // The master already exists; both optional requests fail, but the worker
  // finishes successfully and never tears down/restarts the main SSH session.
  await exec('/bin/bash', [hook], options);
  const forwarded = readFileSync(calls, 'utf8');
  assert.match(forwarded, /-O forward .* -L 3000:localhost:3000/);
  assert.match(
    forwarded,
    /-O forward .* -R \/guest\/clipper.sock:\/host\/clipper.sock/,
  );
});

test('VM SSH requires its reverse forward and exports credentials even without SB_SSH_EXEC', async (t) => {
  const {bin, env} = await generationFixture(t);
  writeFileSync(join(bin, 'ssh'), '#!/bin/bash\nprintf "%s\\n" "$@"\n', {
    mode: 0o755,
  });
  const script = `set -euo pipefail
vm_ip() { echo 127.0.0.1; }
VM_USER=fixture
SSH_OPTS=(-o ControlPath=none)
SB_PORTS=()
SB_SOCKETS=()
SB_SSH_EXEC=''
setup_nono_proxy_for_vm() {
  SB_NONO_PROXY_PORT=12345
  SB_GUEST_PROXY_PORT=4567
  GUEST_ENV_SCRIPT='export FIXTURE_API_KEY=proxied; '
}
${optional}
${ssh}
cmd_ssh
`;
  const result = await exec('/bin/bash', ['-c', script], {env});
  assert.match(result.stdout, /ExitOnForwardFailure=yes/);
  assert.match(result.stdout, /127\.0\.0\.1:4567:127\.0\.0\.1:12345/);
  assert.match(
    result.stdout,
    /export FIXTURE_API_KEY=proxied; export SB_SANDBOX=1\nexec/,
  );
  await assert.rejects(
    exec('/bin/bash', [
      '-c',
      script.replace(
        'cmd_ssh\n',
        'setup_nono_proxy_for_vm() { return 1; }\ncmd_ssh\n',
      ),
    ], {env}),
    (error: Error & {stdout?: string; stderr?: string}) => {
      assert.equal(error.stdout, '');
      assert.match(error.stderr ?? '', /refusing to start/);
      return true;
    },
  );
});
