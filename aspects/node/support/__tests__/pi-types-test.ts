import * as assert from 'node:assert/strict';
import {spawnSync} from 'node:child_process';
import {
  copyFileSync,
  existsSync,
  mkdirSync,
  mkdtempSync,
  readFileSync,
  rmSync,
  writeFileSync,
} from 'node:fs';
import {tmpdir} from 'node:os';
import {join} from 'node:path';
import {test} from 'node:test';
import {fileURLToPath} from 'node:url';

const helper = fileURLToPath(
  new URL(
    '../../../dotfiles/files/.pi/agent/extensions/bin/install-types',
    import.meta.url,
  ),
);

for (const layout of ['hoisted', 'nested']) {
  test(`type copying supports ${layout} dependencies without copying executable code`, (t) => {
    const home = mkdtempSync(join(tmpdir(), 'pi types-'));
    t.after(() => rmSync(home, {recursive: true, force: true}));
    const extensions = join(home, 'extensions');
    const bin = join(extensions, 'bin');
    const dest = join(extensions, 'node_modules');
    const runtime = join(home, 'n/pi/node_modules');
    const pi = join(runtime, '@earendil-works/pi-coding-agent');
    const dependencies = layout === 'hoisted'
      ? runtime
      : join(pi, 'node_modules');
    mkdirSync(bin, {recursive: true});
    mkdirSync(join(dest, 'unmanaged'), {recursive: true});
    writeFileSync(join(dest, '.gitignore'), '*\n!.gitignore\n');
    writeFileSync(join(dest, 'unmanaged/keep'), 'keep');
    copyFileSync(helper, join(bin, 'install-types'));
    writeFileSync(
      join(bin, 'npm'),
      `#!/bin/sh
printf '%s\\n' "$@" > "$HOME/npm.args"
exit 1
`,
      {mode: 0o755},
    );
    const pkg = (root: string, name: string) => {
      mkdirSync(join(root, 'dist'), {recursive: true});
      writeFileSync(
        join(root, 'package.json'),
        JSON.stringify({
          name,
          version: '1.0.0',
          exports: {'.': './dist/index.js'},
        }),
      );
      for (const extension of ['d.ts', 'd.mts', 'd.cts', 'js']) {
        writeFileSync(join(root, `dist/index.${extension}`), name);
      }
    };
    pkg(pi, '@earendil-works/pi-coding-agent');
    const names = [
      '@earendil-works/pi-ai',
      '@earendil-works/pi-tui',
      '@earendil-works/pi-agent-core',
      'typebox',
      '@types/node',
    ];
    for (const name of names) {
      pkg(join(dependencies, name), name);
    }
    // This is a dependency of @types/node, not of Pi itself. Deliberately
    // leave it nested, even in the otherwise hoisted fixture.
    pkg(
      join(dependencies, '@types/node/node_modules/undici-types'),
      'undici-types',
    );
    const result = spawnSync('/bin/sh', [join(bin, 'install-types')], {
      env: {HOME: home, PATH: `${bin}:${process.env.PATH}`},
      encoding: 'utf8',
    });
    assert.equal(result.status, 0, result.stderr);
    for (
      const name of [
        '@earendil-works/pi-coding-agent',
        ...names,
        'undici-types',
      ]
    ) {
      const root = join(dest, name);
      assert.equal(
        JSON.parse(readFileSync(join(root, 'package.json'), 'utf8')).name,
        name,
      );
      for (const extension of ['d.ts', 'd.mts', 'd.cts']) {
        assert.equal(
          readFileSync(join(root, `dist/index.${extension}`), 'utf8'),
          name,
        );
      }
      assert.equal(existsSync(join(root, 'dist/index.js')), false);
      assert.equal(existsSync(join(root, 'node_modules')), false);
    }
    assert.equal(
      readFileSync(join(dest, '.gitignore'), 'utf8'),
      '*\n!.gitignore\n',
    );
    assert.equal(readFileSync(join(dest, 'unmanaged/keep'), 'utf8'), 'keep');
    assert.equal(existsSync(join(home, 'npm.args')), false);
  });
}
