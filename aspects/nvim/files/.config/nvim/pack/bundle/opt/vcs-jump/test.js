#!/usr/bin/env node

const assert = require('assert');
const child_process = require('child_process');
const fs = require('fs');
const os = require('os');
const path = require('path');
const {promisify} = require('util');

const mkdtemp = promisify(fs.mkdtemp);
const readFile = promisify(fs.readFile);
const writeFile = promisify(fs.writeFile);

const EXE = path.join(__dirname, 'bin/vcs-jump');

async function chdir(directory, callback) {
  const cwd = process.cwd();

  try {
    console.log(`-> ${directory}`);

    process.chdir(directory);

    await callback();
  } finally {
    process.chdir(cwd);
  }
}

async function expect(command, expected) {
  let location;

  try {
    throw new Error("Hack to get caller's location");
  } catch (error) {
    [, location] = error.stack.split(/\n/)[2].match(/\((.+)\)/);
  }

  const {stdout} = await command;

  try {
    assert.strictEqual(stdout.trim(), expected.join('\n'));
  } catch (error) {
    console.log(`\nAt: ${location}\n`);

    const [, line, column] = location.match(/(\d+):(\d+)/);

    const contents = await readFile(path.join(__dirname, 'test.js'), 'utf8');

    const lines = contents.split(/\n/);

    console.log(lines[line - 1]);
    console.log(' '.repeat(column - 1) + '^');
    console.log('');

    throw error;
  }
}

async function main() {
  await testGit();
  await testMercurial();
}

async function run(command, ...args) {
  return new Promise((resolve, reject) => {
    const child = child_process.spawn(command, args);

    const description = `${command} ${args.join(' ')}`;

    console.log(description);

    let resolved = false;
    let stderr = '';
    let stdout = '';

    child.on('close', (code, signal) => {
      if (!resolved && !code && !signal) {
        resolve({stderr, stdout});
        resolved = true;
      }
    });

    child.stderr.on('data', data => {
      stderr += data.toString();
    });

    child.stdout.on('data', data => {
      stdout += data.toString();
    });

    child.on('error', error => {
      if (!resolved) {
        reject(`\`${description}\` failed due to error ${error}`);
        resolved = true;
      }
    });

    child.on('exit', (code, signal) => {
      if (!code && !signal) {
        return;
      } else if (!resolved) {
        if (code) {
          reject(`\`${description}\` exited with code ${code}`);
        } else if (signal) {
          reject(`\`${description}\` exited due to signal ${code}`);
        }
        resolved = true;
      }
    });
  });
}

async function sandbox(callback) {
  const prefix = os.tmpdir() + path.sep;

  const directory = await mkdtemp(prefix);

  await chdir(directory, callback);
}

async function shell(strings, ...interpolations) {
  const commands = strings
    .reduce((acc, string, i) => {
      return acc + string + (interpolations[i] || '');
    }, '')
    .split(/\n/)
    .map(line => line.trim())
    .filter(Boolean);

  for (let i = 0; i < commands.length; i++) {
    const {stdout} = await run('sh', '-c', commands[i]);

    if (stdout.trim().length) {
      console.log(stdout.trim());
    }
  }
}

async function testGit() {
  await sandbox(async () => {
    const cwd = process.cwd();

    await shell`
      git init

      echo foo > foo
      mkdir subdir
      echo foo > subdir/foo
      git add foo subdir
      git commit -m foo

      echo bar > bar
      git add bar
      git commit -m bar

      echo baz > baz
      git add baz
      git commit -m baz

      echo more >> foo
      echo more >> subdir/foo
      git add foo subdir
      git commit -m 'More foo'

      echo more >> bar
      git add bar
      git commit -m 'More bar'

      git checkout -b topic HEAD~2

      echo stuff >> bar
      echo stuff >> foo
      echo stuff >> subdir/foo
      git add foo bar subdir
      git commit -m 'More stuff'

      git checkout main
    `;

    /*
     * grep
     */

    await expect(vcsjump('grep', 'foo'), [
      `${cwd}/foo:1:foo`,
      `${cwd}/subdir/foo:1:foo`,
    ]);

    await expect(vcsjump('grep', 'bar'), [
      `${cwd}/bar:1:bar`,
    ]);

    await expect(vcsjump('grep', 'nothing'), []);

    await chdir('subdir', async () => {
      // In subdir, only get subdir results, matching `git grep` behavior.

      await expect(vcsjump('grep', 'foo'), [
        `${cwd}/subdir/foo:1:foo`,
      ]);

      await expect(vcsjump('grep', 'bar'), []);

      await expect(vcsjump('grep', 'nothing'), []);
    });

    /*
     * diff
     */

    await expect(vcsjump('diff'), []);

    await expect(vcsjump('diff', 'HEAD~'), [
      `${cwd}/bar:2: more`,
    ]);

    await expect(vcsjump('diff', 'HEAD~2'), [
      `${cwd}/bar:2: more`,
      `${cwd}/foo:2: more`,
      `${cwd}/subdir/foo:2: more`,
    ]);

    await expect(vcsjump('diff', 'HEAD~3'), [
      `${cwd}/bar:2: more`,
      `${cwd}/baz:1: baz`,
      `${cwd}/foo:2: more`,
      `${cwd}/subdir/foo:2: more`,
    ]);

    await chdir('subdir', async () => {
      // In subdir, get same results as from root dir, matching `git diff`
      // behavior.
      await expect(vcsjump('diff'), []);

      await expect(vcsjump('diff', 'HEAD~'), [
        `${cwd}/bar:2: more`,
      ]);

      await expect(vcsjump('diff', 'HEAD~2'), [
        `${cwd}/bar:2: more`,
        `${cwd}/foo:2: more`,
        `${cwd}/subdir/foo:2: more`,
      ]);

      await expect(vcsjump('diff', 'HEAD~3'), [
        `${cwd}/bar:2: more`,
        `${cwd}/baz:1: baz`,
        `${cwd}/foo:2: more`,
        `${cwd}/subdir/foo:2: more`,
      ]);
    });

    /*
     * merge
     */
    await expect(vcsjump('merge'), []);

    await chdir('subdir', async () => {
      await expect(vcsjump('merge'), []);
    });

    let caught;

    try {
      await run('git', 'merge', '--no-rerere-autoupdate', 'topic')
    } catch (error) {
      caught = error;
    } finally {
      assert.ok(caught);
    }

    await expect(vcsjump('merge'), [
      `${cwd}/bar:2:<<<<<<< HEAD`,
      `${cwd}/foo:2:<<<<<<< HEAD`,
      `${cwd}/subdir/foo:2:<<<<<<< HEAD`,
    ]);

    await chdir('subdir', async () => {
      // In subdir, only get subdir results, matching `git ls-files` behavior.
      await expect(vcsjump('merge'), [
        `${cwd}/subdir/foo:2:<<<<<<< HEAD`,
      ]);
    });
  });
}

async function testMercurial() {
  await sandbox(async () => {
    const cwd = process.cwd();

    await shell`
      hg init
      hg bookmark master

      echo foo > foo
      mkdir subdir
      echo foo > subdir/foo
      hg add foo subdir
      hg commit -m foo

      echo bar > bar
      hg add bar
      hg commit -m bar

      echo baz > baz
      hg add baz
      hg commit -m baz

      echo more >> foo
      echo more >> subdir/foo
      hg commit -m 'More foo' foo subdir

      echo more >> bar
      hg commit -m 'More bar' bar

      hg bookmark topic --rev -3
      hg update topic

      echo stuff >> bar
      echo stuff >> foo
      echo stuff >> subdir/foo
      hg commit -m 'More stuff' foo bar subdir

      hg update master
    `;

    await expect(vcsjump('grep', 'foo'), [
      `${cwd}/foo:1:foo`,
      `${cwd}/subdir/foo:1:foo`,
    ]);

    await expect(vcsjump('grep', 'bar'), [
      `${cwd}/bar:1:bar`,
    ]);

    await expect(vcsjump('grep', 'nothing'), []);

    await chdir('subdir', async () => {
      // In subdir, gets all results, matching `hg grep` behavior.

      await expect(vcsjump('grep', 'foo'), [
        `${cwd}/foo:1:foo`,
        `${cwd}/subdir/foo:1:foo`,
      ]);

      await expect(vcsjump('grep', 'bar'), [
        `${cwd}/bar:1:bar`,
      ]);

      await expect(vcsjump('grep', 'nothing'), []);
    });

    /*
     * diff
     */

    await expect(vcsjump('diff'), []);

    await expect(vcsjump('diff', '-r -3...'), [
      `${cwd}/bar:2: more`,
    ]);

    await expect(vcsjump('diff', '-r -4...'), [
      `${cwd}/bar:2: more`,
      `${cwd}/foo:2: more`,
      `${cwd}/subdir/foo:2: more`,
    ]);

    await expect(vcsjump('diff', '-r -5...'), [
      `${cwd}/bar:2: more`,
      `${cwd}/baz:1: baz`,
      `${cwd}/foo:2: more`,
      `${cwd}/subdir/foo:2: more`,
    ]);

    await chdir('subdir', async () => {
      // In subdir, get same results as from root dir, matching `hg diff`
      // behavior.
      await expect(vcsjump('diff'), []);

      await expect(vcsjump('diff', '-r -3...'), [
        `${cwd}/bar:2: more`,
      ]);

      await expect(vcsjump('diff', '-r -4...'), [
        `${cwd}/bar:2: more`,
        `${cwd}/foo:2: more`,
        `${cwd}/subdir/foo:2: more`,
      ]);

      await expect(vcsjump('diff', '-r -5...'), [
        `${cwd}/bar:2: more`,
        `${cwd}/baz:1: baz`,
        `${cwd}/foo:2: more`,
        `${cwd}/subdir/foo:2: more`,
      ]);
    });

    /*
     * merge
     */
    await expect(vcsjump('merge'), []);

    await chdir('subdir', async () => {
      await expect(vcsjump('merge'), []);
    });

    let caught;

    try {
      await run('hg', 'merge', 'topic')
    } catch (error) {
      caught = error;
    } finally {
      assert.ok(caught);
    }

    await expect(vcsjump('merge'), [
      `${cwd}/bar:2:<<<<<<< working copy`,
      `${cwd}/foo:2:<<<<<<< working copy`,
      `${cwd}/subdir/foo:2:<<<<<<< working copy`,
    ]);

    await chdir('subdir', async () => {
      // In subdir, gets all results, matching `hg resolve` behavior.

      await expect(vcsjump('merge'), [
        `${cwd}/bar:2:<<<<<<< working copy`,
        `${cwd}/foo:2:<<<<<<< working copy`,
        `${cwd}/subdir/foo:2:<<<<<<< working copy`,
      ]);
    });
  });
}

function vcsjump(mode, ...args) {
  return run(EXE, mode, ...args);
}

main()
  .catch(error => {
    console.log(`error: ${error}`);
    process.exit(1);
  });
