import * as assert from 'node:assert/strict';
import {spawnSync} from 'node:child_process';
import {
  copyFileSync,
  existsSync,
  mkdirSync,
  mkdtempSync,
  readFileSync,
  readdirSync,
  readlinkSync,
  rmSync,
  symlinkSync,
  writeFileSync,
} from 'node:fs';
import {tmpdir} from 'node:os';
import {join} from 'node:path';
import {test} from 'node:test';
import {fileURLToPath} from 'node:url';

const source = fileURLToPath(new URL('../pi/', import.meta.url));
const manifest = JSON.parse(readFileSync(join(source, 'package.json'), 'utf8'));
const version = manifest.dependencies['@earendil-works/pi-coding-agent'];

function fixture(t: {after: (fn: () => void) => void}) {
  const home = mkdtempSync(join(tmpdir(), 'pi install-'));
  t.after(() => rmSync(home, {recursive: true, force: true}));
  const bin = join(home, 'n/bin');
  const runtime = join(home, 'n/pi');
  const checkout = join(home, 'checkout');
  mkdirSync(bin, {recursive: true});
  mkdirSync(checkout);
  for (const name of ['install', 'package.json', 'package-lock.json']) {
    copyFileSync(join(source, name), join(checkout, name));
  }
  const legacy = join(home, 'n/legacy-pi');
  writeFileSync(legacy, '#!/bin/sh\necho legacy\n', {mode: 0o755});
  symlinkSync('../legacy-pi', join(bin, 'pi'));
  writeFileSync(
    join(bin, 'npm'),
    `#!/bin/bash
set -eu
printf '%s\\n' "$@" > "$HOME/npm.args"
pwd > "$HOME/npm.cwd"
mkdir -p node_modules/.bin
if [ "\${FAIL_NPM:-}" = 1 ]; then exit 1; fi
printf '#!/bin/sh\\necho %s\\n' "\${MOCK_VERSION:-${version}}" > node_modules/.bin/pi
chmod +x node_modules/.bin/pi
`,
    {mode: 0o755},
  );
  writeFileSync(
    join(bin, 'mv'),
    `#!/bin/bash
if [[ "\${FAIL_ACTIVATION:-}" = 1 && "$1" = "$HOME/n/".pi-install.* && "$1" != */previous && "$2" = "$HOME/n/pi" ]]; then
  exit 1
fi
exec /bin/mv "$@"
`,
    {mode: 0o755},
  );
  const existing = (installed: string) => {
    mkdirSync(join(runtime, 'node_modules/.bin'), {recursive: true});
    writeFileSync(
      join(runtime, 'node_modules/.bin/pi'),
      `#!/bin/sh\necho ${installed}\n`,
      {mode: 0o755},
    );
    writeFileSync(join(runtime, 'old-marker'), 'existing runtime');
  };
  const run = (env: NodeJS.ProcessEnv = {}) =>
    spawnSync('/bin/bash', [join(checkout, 'install')], {
      env: {HOME: home, PATH: process.env.PATH, ...env},
      encoding: 'utf8',
    });
  const clean = () =>
    assert.deepEqual(
      readdirSync(join(home, 'n')).filter((name) =>
        name.startsWith('.pi-install.')
      ),
      [],
    );
  return {home, bin, runtime, checkout, legacy, existing, run, clean};
}

test('installs the approved lock outside the checkout and switches only the command link', (t) => {
  const {home, bin, runtime, checkout, legacy, run, clean} = fixture(t);
  const result = run();
  assert.equal(result.status, 0, result.stderr);
  assert.deepEqual(
    readFileSync(join(home, 'npm.args'), 'utf8').trim().split('\n'),
    [
      'ci',
      '--ignore-scripts',
      '--omit=dev',
      '--include=optional',
      '--min-release-age=7',
    ],
  );
  assert.ok(
    readFileSync(join(home, 'npm.cwd'), 'utf8').startsWith(
      join(home, 'n/.pi-install.'),
    ),
  );
  assert.equal(existsSync(join(checkout, 'node_modules')), false);
  assert.deepEqual(
    readFileSync(join(runtime, 'package-lock.json')),
    readFileSync(join(source, 'package-lock.json')),
  );
  assert.equal(readlinkSync(join(bin, 'pi')), '../pi/node_modules/.bin/pi');
  assert.equal(readFileSync(legacy, 'utf8'), '#!/bin/sh\necho legacy\n');
  assert.equal(
    spawnSync(join(bin, 'pi'), ['--version'], {encoding: 'utf8'}).stdout.trim(),
    version,
  );
  clean();
});

test('matching Pi version skips npm even when the source lock changes, and repairs the command link', (t) => {
  const {home, bin, runtime, checkout, existing, run, clean} = fixture(t);
  existing(version);
  // Deliberately not a fingerprint check (or a check of the global binary).
  writeFileSync(join(checkout, 'package-lock.json'), '{}\n');
  const result = run();
  assert.equal(result.status, 0, result.stderr);
  assert.equal(existsSync(join(home, 'npm.args')), false);
  assert.equal(
    readFileSync(join(runtime, 'old-marker'), 'utf8'),
    'existing runtime',
  );
  assert.equal(readlinkSync(join(bin, 'pi')), '../pi/node_modules/.bin/pi');
  clean();
});

test('version mismatch replaces the runtime without retaining a release history', (t) => {
  const {runtime, existing, run, clean} = fixture(t);
  existing('0.0.1');
  const result = run();
  assert.equal(result.status, 0, result.stderr);
  assert.equal(existsSync(join(runtime, 'old-marker')), false);
  assert.equal(existsSync(join(runtime, 'previous')), false);
  clean();
});

for (
  const failure of [{FAIL_NPM: '1'}, {MOCK_VERSION: 'wrong-version'}, {
    FAIL_ACTIVATION: '1',
  }]
) {
  test(`failure preserves the old runtime and command link: ${JSON.stringify(failure)}`, (t) => {
    const {bin, runtime, existing, run, clean} = fixture(t);
    existing('0.0.1');
    const result = run(failure);
    assert.notEqual(result.status, 0);
    assert.equal(
      readFileSync(join(runtime, 'old-marker'), 'utf8'),
      'existing runtime',
    );
    assert.equal(readlinkSync(join(bin, 'pi')), '../legacy-pi');
    clean();
  });
}

test('a failed first installation can be retried', (t) => {
  const {runtime, run, clean} = fixture(t);
  assert.notEqual(run({FAIL_NPM: '1'}).status, 0);
  assert.equal(existsSync(runtime), false);
  clean();
  const result = run();
  assert.equal(result.status, 0, result.stderr);
  clean();
});

test('lock pins the manifest, has registry integrity for every package, and retains platform optionals', () => {
  const lock = JSON.parse(
    readFileSync(join(source, 'package-lock.json'), 'utf8'),
  );
  assert.deepEqual(lock.packages[''].dependencies, manifest.dependencies);
  assert.equal(
    lock.packages['node_modules/@earendil-works/pi-coding-agent'].version,
    version,
  );
  const packages = Object.entries(lock.packages).filter(([name]) => name);
  for (const [name, entry] of packages) {
    const pkg = entry as {integrity: string; resolved: string};
    assert.match(pkg.integrity, /^sha512-[A-Za-z0-9+/]+=*$/, name);
    assert.match(pkg.resolved, /^https:\/\/registry\.npmjs\.org\//, name);
  }
  for (const platform of ['darwin-arm64', 'linux-arm64']) {
    assert.ok(
      packages.some(([name]) => name.endsWith(`/@esbuild/${platform}`)),
    );
  }
});
