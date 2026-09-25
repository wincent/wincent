import * as assert from 'node:assert';
import {execFile} from 'node:child_process';
import {cp, mkdir, mkdtemp, rm, writeFile} from 'node:fs/promises';
import {tmpdir} from 'node:os';
import {basename, join} from 'node:path';
import {test} from 'node:test';
import {promisify} from 'node:util';

import root from '../dsl/root.ts';

import type {TestContext} from 'node:test';

const exec = promisify(execFile);
const imports = `
import Context from '../../fig/Context.ts';
import task from '../../fig/dsl/task.ts';
import handler from '../../fig/dsl/handler.ts';
import variable from '../../fig/dsl/variable.ts';
import variables from '../../fig/dsl/variables.ts';
import {setTimeout as delay} from 'node:timers/promises';
`;

// Run the actual entrypoint against a temporary, self-contained project. No
// real aspect is imported, and fixture tasks only emit events or wait.
async function project(t: TestContext, sources: Record<string, string>) {
  const directory = await mkdtemp(join(tmpdir(), 'fig-scheduler-test-'));
  t.after(() => rm(directory, {recursive: true, force: true}));
  await cp(join(root, 'fig'), join(directory, 'fig'), {
    recursive: true,
    filter: (source) => basename(source) !== '__tests__',
  });
  await mkdir(join(directory, 'home'));
  await writeFile(join(directory, 'package.json'), '{"type":"module"}');
  await writeFile(join(directory, 'variables.ts'), 'export default {};');
  await writeFile(join(directory, 'helpers.ts'), 'export {};');
  await writeFile(
    join(directory, 'support.ts'),
    `
export const dotfilesStarted = Promise.withResolvers<void>();
export const metaStarted = Promise.withResolvers<void>();
`,
  );
  const platform = {aspects: [['dotfiles', 'meta'], 'node']};
  await writeFile(
    join(directory, 'fig.config.ts'),
    `export default ${
      JSON.stringify({
        platforms: {darwin: platform, linux: platform},
        variables: {example: 'global'},
      })
    };`,
  );

  for (const [aspect, source] of Object.entries(sources)) {
    const aspectDir = join(directory, 'aspects', aspect);
    await mkdir(aspectDir, {recursive: true});
    await writeFile(
      join(aspectDir, 'aspect.json'),
      JSON.stringify({
        description: 'Scheduler test fixture',
        variables: {example: aspect},
      }),
    );
    await writeFile(join(aspectDir, 'index.ts'), imports + source);
  }

  return async (...args: Array<string>) => {
    const result = await exec(process.execPath, ['fig/main.mts', ...args], {
      cwd: directory,
      env: {
        ...process.env,
        HOME: join(directory, 'home'),
        YOLO: '1',
        NON_INTERACTIVE: '1',
      },
      timeout: 10_000,
    }).then(
      ({stdout, stderr}) => ({status: 0, stdout, stderr}),
      (error) => {
        assert.strictEqual(typeof error.code, 'number', String(error));
        return {
          status: error.code as number,
          stdout: error.stdout as string,
          stderr: error.stderr as string,
        };
      },
    );
    return {
      ...result,
      events: result.stdout.split(/\r?\n/).filter((line) =>
        line.startsWith('EVENT ')
      ),
    };
  };
}

test('parallel groups retain runtime context and finish before the next batch', async (t) => {
  const source = (aspect: string, other: string) => `
import * as assert from 'node:assert';
import {${aspect}Started, ${other}Started} from '../../support.ts';
variables(async (vars) => {
  await delay(0);
  assert.strictEqual(variable('example'), vars.example);
  assert.strictEqual(Context.currentAspect, '${aspect}');
  return {example: 'derived-${aspect}'};
});
task('run', async () => {
  ${aspect}Started.resolve();
  await ${other}Started.promise;
  await new Promise((resolve) => setTimeout(() => {
    assert.strictEqual(Context.currentAspect, '${aspect}');
    assert.strictEqual(Context.currentTask, '${aspect} | run');
    assert.strictEqual(variable('example'), 'derived-${aspect}');
    resolve();
  }, 0));
  console.log('EVENT ${aspect} task');
  await Context.informChanged('fixture', 'reload');
});
handler('reload', async () => {
  await delay(0);
  assert.strictEqual(Context.currentTask, '${aspect} | reload');
  assert.strictEqual(variable('example'), 'derived-${aspect}');
  console.log('EVENT ${aspect} handler');
});
`;
  const run = await project(t, {
    dotfiles: source('dotfiles', 'meta'),
    meta: source('meta', 'dotfiles'),
    node:
      "task('next batch', async () => { console.log('EVENT next batch'); });",
  });

  const result = await run('--parallel');
  assert.strictEqual(result.status, 0, result.stderr);
  assert.deepStrictEqual(result.events.slice(0, 4).sort(), [
    'EVENT dotfiles handler',
    'EVENT dotfiles task',
    'EVENT meta handler',
    'EVENT meta task',
  ]);
  assert.strictEqual(result.events[4], 'EVENT next batch');
  assert.match(result.stderr, /Summary: changed=2 failed=0/);
});

test('failure drains active tasks and stops further tasks, handlers and batches', async (t) => {
  const run = await project(t, {
    dotfiles: `
import {metaStarted} from '../../support.ts';
task('fail', async () => {
  await metaStarted.promise;
  throw new Error('expected failure');
});
task('not started', async () => { console.log('EVENT unwanted dotfiles task'); });
`,
    meta: `
import {metaStarted} from '../../support.ts';
task('active', async () => {
  metaStarted.resolve();
  await delay(100);
  console.log('EVENT active finished');
  await Context.informChanged('active finished', 'reload');
});
task('not started', async () => { console.log('EVENT unwanted meta task'); });
handler('reload', async () => { console.log('EVENT unwanted handler'); });
`,
    node:
      "task('not started', async () => { console.log('EVENT unwanted batch'); });",
  });

  const result = await run('--parallel');
  assert.strictEqual(result.status, 1, result.stderr);
  assert.deepStrictEqual(result.events, ['EVENT active finished']);
  assert.match(result.stderr, /task `dotfiles \| fail` failed/);
  assert.match(result.stderr, /Summary: changed=1 failed=1/);
  assert.ok(
    result.stderr.indexOf('Changed: active finished') <
      result.stderr.indexOf('Summary:'),
  );
});

test('derivation failure also drains active siblings before exiting', async (t) => {
  const run = await project(t, {
    dotfiles: `
import {metaStarted} from '../../support.ts';
variables(async () => {
  await metaStarted.promise;
  throw new Error('derivation failed');
});
task('not started', async () => { console.log('EVENT unwanted task'); });
`,
    meta: `
import {metaStarted} from '../../support.ts';
task('active', async () => {
  metaStarted.resolve();
  await delay(100);
  console.log('EVENT active finished');
});
task('not started', async () => { console.log('EVENT unwanted task'); });
`,
    node:
      "task('not started', async () => { console.log('EVENT unwanted batch'); });",
  });

  const result = await run('--parallel');
  assert.strictEqual(result.status, 1, result.stderr);
  assert.deepStrictEqual(result.events, ['EVENT active finished']);
  assert.match(result.stderr, /derivation failed/);
});

test('--start-at-task serializes parallel groups and skips earlier tasks', async (t) => {
  const run = await project(t, {
    dotfiles: `
variables(async () => { await delay(30); return {}; });
task('before target', async () => { console.log('EVENT unwanted dotfiles task'); });
`,
    meta: `
task('before target', async () => { console.log('EVENT unwanted meta task'); });
task('target', async () => { console.log('EVENT target'); });
task('after target', async () => { console.log('EVENT after target'); });
`,
    node:
      "task('next batch', async () => { console.log('EVENT next batch'); });",
  });

  const result = await run('--parallel', '--start-at-task', 'meta | target');
  assert.strictEqual(result.status, 0, result.stderr);
  assert.deepStrictEqual(result.events, [
    'EVENT target',
    'EVENT after target',
    'EVENT next batch',
  ]);
});
