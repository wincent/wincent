import * as assert from 'node:assert/strict';
import {spawnSync} from 'node:child_process';
import {
  existsSync,
  mkdirSync,
  mkdtempSync,
  rmSync,
  writeFileSync,
} from 'node:fs';
import {homedir, tmpdir} from 'node:os';
import {dirname, join} from 'node:path';
import {test} from 'node:test';

import {stripJsoncLineComments} from '../nono-proxy.ts';
import {renderFixtureProfile} from './nono-profile-fixture.ts';

const profile = JSON.parse(stripJsoncLineComments(renderFixtureProfile(null)));
const piPaths = (paths: string[]) =>
  paths.filter((path) => path.startsWith('~/.pi'));

test('Pi profile keeps config read-only with exact runtime and lock exceptions', () => {
  assert.deepEqual(piPaths(profile.filesystem.allow), [
    '~/.pi/agent/sessions',
    '~/.pi/agent/subagent-sessions',
  ]);
  assert.deepEqual(profile.filesystem.allow_file, [
    '~/.pi/agent/auth.json',
    '~/.pi/agent/auth.json.lock',
    '~/.pi/agent/models-store.json',
    '~/.pi/agent/models-store.json.lock',
    '~/.pi/agent/settings.json.lock',
    '~/.pi/agent/trust.json.lock',
  ]);
  for (
    const file of [
      'settings.json',
      'models.json',
      'trust.json',
      'AGENTS.md',
      'mcp.json',
    ]
  ) {
    assert.ok(profile.filesystem.read_file.includes(`~/.pi/agent/${file}`));
  }
  assert.ok(profile.filesystem.read.includes('~/.pi/agent/extensions'));
});

test('Pi profile grants read-only access to an optional external Git hooks directory', () => {
  const hooks = '$NONO_GIT_HOOKS_PATH';
  assert.ok(profile.filesystem.read.includes(hooks));
  for (const field of ['allow', 'allow_file']) {
    for (const path of profile.filesystem[field]) {
      assert.ok(
        path !== hooks && !hooks.startsWith(path + '/') &&
          !path.startsWith(hooks + '/'),
        `${field} must not grant write access to ${hooks}: ${path}`,
      );
    }
  }
});

// Opt in on a trusted macOS host. The fixture MUST NOT live under /tmp or
// TMPDIR: default writable temp grants would hide a broken Pi policy.
test(
  'nono enforces installed Pi config/state permissions, including absent locks',
  {
    skip: process.platform !== 'darwin' ||
      process.env.NONO_PI_INTEGRATION !== '1',
    timeout: 60_000,
  },
  (t) => {
    const home = mkdtempSync(join(homedir(), '.pi-policy-test-'));
    const temp = mkdtempSync(join(tmpdir(), 'pi-policy-temp-'));
    t.after(() => {
      rmSync(home, {recursive: true, force: true});
      rmSync(temp, {recursive: true, force: true});
    });
    const agent = join(home, '.pi/agent');
    const workspace = join(home, 'project');
    mkdirSync(join(agent, 'sessions'), {recursive: true});
    mkdirSync(join(agent, 'extensions'));
    mkdirSync(workspace);
    for (
      const file of [
        'models.json',
        'mcp.json',
        'AGENTS.md',
        'extensions/example.ts',
      ]
    ) {
      writeFileSync(join(agent, file), '{}\n');
    }
    writeFileSync(
      join(agent, 'settings.json'),
      '{"defaultModel":"fixture-model"}\n',
    );
    writeFileSync(
      join(agent, 'trust.json'),
      JSON.stringify({[workspace]: true}),
    );
    writeFileSync(join(agent, 'unlisted-secret'), 'not granted');
    const runtime = process.env.PI_TEST_RUNTIME ?? join(homedir(), 'n/pi');
    const core = join(
      runtime,
      'node_modules/@earendil-works/pi-coding-agent/dist/core',
    );
    const hasRuntime = existsSync(join(core, 'auth-storage.js'));
    const filesystem: Record<string, string[]> = {};
    for (const field of ['allow', 'allow_file', 'read', 'read_file']) {
      filesystem[field] = piPaths(profile.filesystem[field]).map((path) =>
        path.replace('~', home)
      );
    }
    filesystem.read.push(dirname(process.execPath));
    if (hasRuntime) {
      filesystem.read.push(runtime);
    }
    const path = join(temp, 'profile.json');
    writeFileSync(
      path,
      JSON.stringify({
        extends: profile.extends,
        workdir: profile.workdir,
        filesystem,
      }),
    );
    const fullProfile = join(temp, 'full.jsonc');
    writeFileSync(fullProfile, renderFixtureProfile(null));
    for (const fixture of [path, fullProfile]) {
      const validation = spawnSync('nono', ['profile', 'validate', fixture], {
        encoding: 'utf8',
      });
      assert.equal(validation.status, 0, validation.stderr);
    }
    const probe = `
    const assert = require('node:assert/strict');
    const fs = require('node:fs');
    const {join} = require('node:path');
    const {pathToFileURL} = require('node:url');
    const agent = ${JSON.stringify(agent)};
    const workspace = ${JSON.stringify(workspace)};
    function denied(fn) {
      assert.throws(fn, error => ['EPERM', 'EACCES'].includes(error.code));
    }
    async function main() {
      // Test actual file creation/deletion, not only nono's policy explainer.
      for (const name of ['auth.json', 'models-store.json']) {
        fs.writeFileSync(join(agent, name), '{}');
        fs.writeFileSync(join(agent, name), '{}');
      }
      for (const name of ['auth.json', 'models-store.json', 'settings.json', 'trust.json']) {
        const lock = join(agent, name + '.lock');
        // Second launch tests paths that were directories at policy creation.
        if (fs.existsSync(lock)) fs.rmdirSync(lock);
        for (let i = 0; i < 2; i++) {
          fs.mkdirSync(lock);
          fs.utimesSync(lock, new Date(), new Date());
          denied(() => fs.writeFileSync(join(lock, 'child'), 'no'));
          fs.rmdirSync(lock);
        }
      }
      for (const name of ['settings.json', 'models.json', 'trust.json', 'mcp.json', 'AGENTS.md', 'extensions/example.ts']) {
        const path = join(agent, name);
        const before = fs.readFileSync(path, 'utf8');
        denied(() => fs.writeFileSync(path, 'no'));
        denied(() => fs.unlinkSync(path));
        denied(() => fs.linkSync(path, join(agent, 'sessions/config-hardlink')));
        const alias = join(agent, 'sessions/config-symlink');
        fs.symlinkSync(path, alias);
        denied(() => fs.writeFileSync(alias, 'no'));
        fs.unlinkSync(alias);
        const replacement = join(workspace, 'replacement');
        fs.writeFileSync(replacement, 'no');
        denied(() => fs.renameSync(replacement, path));
        assert.equal(fs.readFileSync(path, 'utf8'), before);
      }
      denied(() => fs.readFileSync(join(agent, 'unlisted-secret')));
      denied(() => fs.writeFileSync(join(agent, 'SYSTEM.md'), 'no'));
      denied(() => fs.writeFileSync(join(agent, 'extensions/planted.ts'), 'no'));
      denied(() => fs.mkdirSync(join(agent, 'new-config')));
      denied(() => fs.symlinkSync(workspace, join(agent, 'prompts')));
      fs.writeFileSync(join(agent, 'sessions/fixture.jsonl'), 'ok');
      fs.unlinkSync(join(agent, 'sessions/fixture.jsonl'));
      if (${hasRuntime}) {
        const core = ${JSON.stringify(core)};
        const load = name => import(pathToFileURL(join(core, name)).href);
        const {FileAuthStorageBackend} = await load('auth-storage.js');
        const {FileModelsStore} = await load('models-store.js');
        const {SettingsManager} = await load('settings-manager.js');
        const {ProjectTrustStore} = await load('trust-manager.js');
        const auth = new FileAuthStorageBackend(join(agent, 'auth.json'));
        auth.withLock(() => ({result: null, next: JSON.stringify({fixture: true})}));
        await auth.withLockAsync(async content => {
          assert.equal(JSON.parse(content).fixture, true);
          return {result: null};
        });
        const models = new FileModelsStore(join(agent, 'models-store.json'));
        await models.write('fixture', {models: []});
        assert.deepEqual(await models.read('fixture'), {models: []});
        const settings = SettingsManager.create(workspace, agent);
        assert.equal(settings.getDefaultModel(), 'fixture-model');
        assert.deepEqual(settings.drainErrors(), []);
        settings.setDefaultModel('not-persisted');
        await settings.flush();
        assert.ok(settings.drainErrors().length);
        assert.equal(JSON.parse(fs.readFileSync(join(agent, 'settings.json'))).defaultModel, 'fixture-model');
        const trust = new ProjectTrustStore(agent);
        assert.equal(trust.get(workspace), true);
        denied(() => trust.set(workspace, false));
        assert.equal(trust.get(workspace), true);
        for (const name of ['auth.json', 'models-store.json', 'settings.json', 'trust.json']) {
          assert.equal(fs.existsSync(join(agent, name + '.lock')), false);
        }
        console.log('Pi storage reads, writes and lock cleanup verified');
      }
      console.log('config read-only; narrow runtime grants verified');
    }
    main().catch(error => { console.error(error); process.exitCode = 1; });
  `;
    for (const existingLocks of [false, true]) {
      if (existingLocks) {
        for (
          const name of [
            'auth.json',
            'models-store.json',
            'settings.json',
            'trust.json',
          ]
        ) {
          mkdirSync(join(agent, name + '.lock'));
        }
      }
      const result = spawnSync('nono', [
        'run',
        '--profile',
        path,
        '--allow-cwd',
        '--block-net',
        '--no-audit',
        '--no-rollback',
        '--no-diagnostics',
        '--',
        process.execPath,
        '-e',
        probe,
      ], {
        cwd: workspace,
        env: {
          ...process.env,
          HOME: home,
          TMPDIR: temp,
          XDG_STATE_HOME: join(home, 'state'),
          XDG_CACHE_HOME: join(temp, 'cache'),
          PI_CODING_AGENT_DIR: agent,
        },
        encoding: 'utf8',
        timeout: 45_000,
      });
      assert.equal(result.status, 0, result.stdout + result.stderr);
      assert.match(result.stdout, /narrow runtime grants verified/);
      if (hasRuntime) {
        assert.match(
          result.stdout,
          /Pi storage reads, writes and lock cleanup verified/,
        );
      } else {
        t.diagnostic(
          'Installed Pi runtime not found; tested syscalls only. Set PI_TEST_RUNTIME for storage integration.',
        );
      }
    }
  },
);
