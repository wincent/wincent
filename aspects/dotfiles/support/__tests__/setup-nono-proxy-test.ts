import * as assert from 'node:assert/strict';
import {spawnSync} from 'node:child_process';
import {
  chmodSync,
  existsSync,
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

const script = fileURLToPath(new URL('../setup-nono-proxy', import.meta.url));

function fixture(t: {after: (fn: () => void) => void}) {
  const home = mkdtempSync(join(tmpdir(), 'nono proxy setup-'));
  t.after(() => rmSync(home, {recursive: true, force: true}));
  const state = join(home, '.local/state/nono-proxy');
  const bin = join(home, 'bin');
  mkdirSync(bin);
  writeFileSync(join(home, 'roots'), 'system-roots');
  writeFileSync(
    join(bin, 'security'),
    '#!/bin/bash\nset -e\nprintf "%s\\n" "$@" > "$HOME/security.calls"\ncat "$HOME/roots"\n',
    {mode: 0o755},
  );
  writeFileSync(
    join(bin, 'openssl'),
    `#!/bin/bash
set -eu
printf '%s\\n' "$@" >> "$HOME/openssl.calls"
operation="$1"
shift
case "$operation" in
  x509) [ "$(cat "$2")" = fresh-ca ] ;;
  req)
    while [ "$#" -gt 0 ]; do
      case "$1" in
        -keyout) shift; printf 'fresh-key\\n' > "$1" ;;
        -out) shift; printf 'fresh-ca\\n' > "$1" ;;
      esac
      shift
    done
    ;;
  rand) printf '0123456789abcdef0123456789abcdef\\n' ;;
  *) exit 1 ;;
esac
if [ "$operation" = "\${FAIL_OPENSSL:-}" ]; then
  exit 1
fi
`,
    {mode: 0o755},
  );
  const run = (env: NodeJS.ProcessEnv = {}) =>
    spawnSync('/bin/bash', [script], {
      env: {HOME: home, PATH: `${bin}:${process.env.PATH}`, ...env},
      encoding: 'utf8',
    });
  const read = (name: string) => readFileSync(join(state, name), 'utf8');
  const clean = () =>
    assert.deepEqual(
      readdirSync(state).filter((name) => name.startsWith('.setup.')),
      [],
    );
  return {home, state, run, read, clean};
}

test('setup provisions private proxy state using EC credentials and macOS roots', (t) => {
  const {home, state, run, read, clean} = fixture(t);
  const result = run();
  assert.equal(result.status, 0, result.stderr);
  assert.equal(read('ca.crt'), 'fresh-ca\n');
  assert.equal(read('ca.key'), 'fresh-key\n');
  assert.equal(read('bundle.crt'), 'system-roots\nfresh-ca\n');
  assert.match(read('pass'), /^[a-f0-9]{32}\n$/);
  assert.equal(statSync(state).mode & 0o777, 0o700);
  for (const name of ['ca.key', 'pass', 'bundle.crt']) {
    assert.equal(statSync(join(state, name)).mode & 0o777, 0o600);
  }
  const calls = readFileSync(join(home, 'openssl.calls'), 'utf8');
  assert.match(calls, /-newkey\nec\n-pkeyopt\nec_paramgen_curve:prime256v1\n/);
  assert.match(calls, /-days\n365\n/);
  assert.match(calls, /-addext\nbasicConstraints=critical,CA:TRUE\n/);
  assert.match(calls, /rand\n-hex\n16\n/);
  assert.equal(
    readFileSync(join(home, 'security.calls'), 'utf8'),
    'find-certificate\n-a\n-p\n/System/Library/Keychains/SystemRootCertificates.keychain\n',
  );
  clean();
});

test('reruns preserve a valid CA and password, refresh roots, and enforce permissions', (t) => {
  const {home, state, run, read, clean} = fixture(t);
  assert.equal(run().status, 0);
  writeFileSync(join(state, 'ca.key'), 'existing-key\n');
  writeFileSync(join(state, 'pass'), 'existing-password\n');
  chmodSync(state, 0o755);
  for (const name of ['ca.key', 'pass']) {
    chmodSync(join(state, name), 0o644);
  }
  writeFileSync(join(home, 'roots'), 'updated-roots\n');
  writeFileSync(join(home, 'openssl.calls'), '');
  for (let i = 0; i < 2; i++) {
    const result = run();
    assert.equal(result.status, 0, result.stderr);
    assert.equal(read('ca.crt'), 'fresh-ca\n');
    assert.equal(read('ca.key'), 'existing-key\n');
    assert.equal(read('pass'), 'existing-password\n');
    assert.equal(read('bundle.crt'), 'updated-roots\nfresh-ca\n');
    clean();
  }
  assert.doesNotMatch(
    readFileSync(join(home, 'openssl.calls'), 'utf8'),
    /req|rand/,
  );
  assert.equal(statSync(state).mode & 0o777, 0o700);
  for (const name of ['ca.key', 'pass']) {
    assert.equal(statSync(join(state, name)).mode & 0o777, 0o600);
  }
});

for (const damage of ['expired', 'missing-cert', 'missing-key']) {
  test(`setup repairs CA state (${damage}) without rotating the password`, (t) => {
    const {state, run, read, clean} = fixture(t);
    assert.equal(run().status, 0);
    writeFileSync(join(state, 'pass'), 'existing-password\n');
    if (damage === 'expired') {
      writeFileSync(join(state, 'ca.crt'), 'expired-ca\n');
    } else {
      rmSync(join(state, damage === 'missing-cert' ? 'ca.crt' : 'ca.key'));
    }
    const result = run();
    assert.equal(result.status, 0, result.stderr);
    assert.equal(read('ca.crt'), 'fresh-ca\n');
    assert.equal(read('ca.key'), 'fresh-key\n');
    assert.equal(read('bundle.crt'), 'system-roots\nfresh-ca\n');
    assert.equal(read('pass'), 'existing-password\n');
    clean();
  });
}

for (const failure of ['req', 'security', 'rand']) {
  test(`setup preserves installed files and cleans up after ${failure} failure`, (t) => {
    const {home, state, run, read, clean} = fixture(t);
    assert.equal(run().status, 0);
    writeFileSync(join(state, 'ca.crt'), 'expired-ca\n');
    writeFileSync(join(state, 'ca.key'), 'existing-key\n');
    if (failure === 'security') {
      rmSync(join(home, 'roots'));
    } else if (failure === 'rand') {
      rmSync(join(state, 'pass'));
    }
    const result = run({FAIL_OPENSSL: failure});
    assert.notEqual(result.status, 0);
    assert.equal(read('ca.crt'), 'expired-ca\n');
    assert.equal(read('ca.key'), 'existing-key\n');
    assert.equal(read('bundle.crt'), 'system-roots\nfresh-ca\n');
    if (failure === 'rand') {
      assert.equal(existsSync(join(state, 'pass')), false);
    } else {
      assert.match(read('pass'), /^[a-f0-9]{32}\n$/);
    }
    clean();
  });
}
