import {equal, ok} from 'assert';
import {join} from 'path';

import {
    command,
    fail,
    file,
    handler,
    path as toPath,
    resource,
    task,
    template,
} from 'fig';
import Context from 'fig/Context.js';
import assert from 'fig/assert.js';
import {promises} from 'fig/fs.js';
import stat from 'fig/fs/stat.js';
import tempdir from 'fig/fs/tempdir.js';

function live() {
    return !Context.currentOptions?.check;
}

const expect = {
    equal(actual: any, expected: any, message?: string | Error | undefined) {
        if (live()) {
            equal(actual, expected, message);
        }
    },

    ok(value: any, message?: string | Error | undefined) {
        if (live()) {
            ok(value, message);
        }
    },
};

const fs = {
    async readFile(name: string, encoding: BufferEncoding) {
        if (live()) {
            return promises.readFile(name, encoding);
        } else {
            return '';
        }
    },

    async stat(name: string) {
        if (live()) {
            return promises.stat(name);
        } else {
            return {
                mtimeMs: 1000,
            };
        }
    },

    async utimes(path: string, atime: number, mtime: number) {
        if (live()) {
            await promises.utimes(path, atime, mtime);
        }
    },
};

const DEFAULT_STATS = {
    mode: '0644',
    target: undefined,
    type: 'file',
};

task('copy a file', async () => {
    //
    // 1. Create a file for the first time.
    //
    let path = join(await tempdir('meta'), 'example.txt');

    let {changed, failed, ok, skipped} = Context.counts;

    // This time showing use of "src".
    await file({
        path,
        src: resource.file('example.txt'),
        state: 'file',
    });

    let contents = await fs.readFile(path, 'utf8');

    expect.equal(contents, 'Some example content.\n');

    expect.equal(Context.counts.changed, changed + 1);
    expect.equal(Context.counts.failed, failed);
    expect.equal(Context.counts.ok, ok);
    expect.equal(Context.counts.skipped, skipped);

    //
    // 2. Overwrite an existing file.
    //
    ({changed, failed, ok, skipped} = Context.counts);

    // This time showing use of "contents".
    await file({
        contents: 'New content!\n',
        path,
        state: 'file',
    });

    contents = await fs.readFile(path, 'utf8');

    expect.equal(contents, 'New content!\n');

    expect.equal(Context.counts.changed, changed + 1);
    expect.equal(Context.counts.failed, failed);
    expect.equal(Context.counts.ok, ok);
    expect.equal(Context.counts.skipped, skipped);

    //
    // 3. When no changes needed.
    //
    ({changed, failed, ok, skipped} = Context.counts);

    await file({
        contents: 'New content!\n',
        path,
        state: 'file',
    });

    contents = await fs.readFile(path, 'utf8');

    expect.equal(contents, 'New content!\n');

    expect.equal(Context.counts.changed, changed);
    expect.equal(Context.counts.failed, failed);
    expect.equal(Context.counts.ok, ok + 1);
    expect.equal(Context.counts.skipped, skipped);

    //
    // 4. Creating an empty file (no "src", no "content").
    //
    path = path.replace(/\.txt$/, '.txt.bak');

    ({changed, failed, ok, skipped} = Context.counts);

    await file({
        path,
        state: 'file',
    });

    contents = await fs.readFile(path, 'utf8');

    expect.equal(contents, '');

    expect.equal(Context.counts.changed, changed + 1);
    expect.equal(Context.counts.failed, failed);
    expect.equal(Context.counts.ok, ok);
    expect.equal(Context.counts.skipped, skipped);
});

task('create a directory', async () => {
    //
    // 1. Create a directory for the first time.
    //
    const path = join(await tempdir('meta'), 'a-directory');

    let {changed, failed, ok, skipped} = Context.counts;

    await file({
        path,
        state: 'directory',
    });

    let stats = live() ? await stat(path) : DEFAULT_STATS;

    assert(stats && !(stats instanceof Error));

    expect.equal(stats.type, 'directory');

    const mode = (0o777 - parseInt(Context.attributes.umask, 8))
        .toString(8)
        .padStart(4, '0');

    expect.equal(stats.mode, mode);

    expect.equal(Context.counts.changed, changed + 1);
    expect.equal(Context.counts.failed, failed);
    expect.equal(Context.counts.ok, ok);
    expect.equal(Context.counts.skipped, skipped);

    //
    // 2. Changing mode of an existing directory.
    //

    ({changed, failed, ok, skipped} = Context.counts);

    await file({
        mode: '0700',
        path,
        state: 'directory',
    });

    stats = live() ? await stat(path) : DEFAULT_STATS;

    assert(stats && !(stats instanceof Error));

    expect.equal(stats.mode, '0700');

    expect.equal(Context.counts.changed, changed + 1);
    expect.equal(Context.counts.failed, failed);
    expect.equal(Context.counts.ok, ok);
    expect.equal(Context.counts.skipped, skipped);

    //
    // 3. A no-op.
    //

    ({changed, failed, ok, skipped} = Context.counts);

    await file({
        path,
        state: 'directory',
    });

    stats = live() ? await stat(path) : DEFAULT_STATS;

    assert(stats && !(stats instanceof Error));

    expect.equal(stats.mode, '0700');

    expect.equal(Context.counts.changed, changed);
    expect.equal(Context.counts.failed, failed);
    expect.equal(Context.counts.ok, ok + 1);
    expect.equal(Context.counts.skipped, skipped);
});

task('manage a symbolic link', async () => {
    //
    // 1. Create a link.
    //
    let path = join(await tempdir('meta'), 'example.txt');

    const src = resource.file('example.txt');

    let {changed, failed, ok, skipped} = Context.counts;

    await file({
        path,
        src,
        state: 'link',
    });

    let contents = await fs.readFile(path, 'utf8');

    expect.equal(contents, 'Some example content.\n');

    let stats = live() ? await stat(path) : DEFAULT_STATS;

    assert(stats && !(stats instanceof Error));

    expect.equal(stats.type, 'link');
    expect.equal(stats.target, toPath(src).resolve);

    expect.equal(Context.counts.changed, changed + 1);
    expect.equal(Context.counts.failed, failed);
    expect.equal(Context.counts.ok, ok);
    expect.equal(Context.counts.skipped, skipped);
});

task('template a file', async () => {
    //
    // 1. Create file from template.
    //
    const path = join(await tempdir('meta'), 'sample.txt');

    let {changed, failed, ok, skipped} = Context.counts;

    await template({
        path,
        src: resource.template('sample.txt.erb'),
        variables: {
            greeting: 'Hello',
            names: ['Bob', 'Jane'],
        },
    });

    let contents = await fs.readFile(path, 'utf8');

    expect.equal(contents, 'Hello Bob, Jane!\n');

    expect.equal(Context.counts.changed, changed + 1);
    expect.equal(Context.counts.failed, failed);
    expect.equal(Context.counts.ok, ok);
    expect.equal(Context.counts.skipped, skipped);

    //
    // 2. Show that running again is a no-op.
    //
    ({changed, failed, ok, skipped} = Context.counts);

    await template({
        path,
        src: resource.template('sample.txt.erb'),
        variables: {
            greeting: 'Hello',
            names: ['Bob', 'Jane'],
        },
    });

    contents = await fs.readFile(path, 'utf8');

    expect.equal(contents, 'Hello Bob, Jane!\n');

    expect.equal(Context.counts.changed, changed);
    expect.equal(Context.counts.failed, failed);
    expect.equal(Context.counts.ok, ok + 1);
    expect.equal(Context.counts.skipped, skipped);

    //
    // 3. Show that we can change an existing file if required.
    //
    // 3a. Just a content change.
    //
    ({changed, failed, ok, skipped} = Context.counts);

    await template({
        path,
        src: resource.template('sample.txt.erb'),
        variables: {
            greeting: 'Hi',
            names: ['Jim', 'Mary', 'Carol'],
        },
    });

    expect.equal(Context.counts.changed, changed + 1);
    expect.equal(Context.counts.failed, failed);
    expect.equal(Context.counts.ok, ok);
    expect.equal(Context.counts.skipped, skipped);

    contents = await fs.readFile(path, 'utf8');

    expect.equal(contents, 'Hi Jim, Mary, Carol!\n');

    //
    // 3b. Just a mode change.
    //
    ({changed, failed, ok, skipped} = Context.counts);

    await template({
        mode: '0600',
        path,
        src: resource.template('sample.txt.erb'),
        variables: {
            greeting: 'Hi',
            names: ['Jim', 'Mary', 'Carol'],
        },
    });

    expect.equal(Context.counts.changed, changed + 1);
    expect.equal(Context.counts.failed, failed);
    expect.equal(Context.counts.ok, ok);
    expect.equal(Context.counts.skipped, skipped);

    contents = await fs.readFile(path, 'utf8');

    expect.equal(contents, 'Hi Jim, Mary, Carol!\n');

    let stats = live() ? await stat(path) : DEFAULT_STATS;

    assert(stats && !(stats instanceof Error));

    expect.equal(stats.mode, '0600');

    //
    // 3c. A mode and a content change.
    //
    ({changed, failed, ok, skipped} = Context.counts);

    await template({
        mode: '0644',
        path,
        src: resource.template('sample.txt.erb'),
        variables: {
            greeting: 'Yo',
            names: ['Derek'],
        },
    });

    expect.equal(Context.counts.changed, changed + 1);
    expect.equal(Context.counts.failed, failed);
    expect.equal(Context.counts.ok, ok);
    expect.equal(Context.counts.skipped, skipped);

    contents = await fs.readFile(path, 'utf8');

    expect.equal(contents, 'Yo Derek!\n');

    stats = live() ? await stat(path) : DEFAULT_STATS;

    assert(stats && !(stats instanceof Error));

    expect.equal(stats.mode, '0644');
});

task('touch an item', async () => {
    //
    // 1. Create a file for the first time.
    //
    let path = join(await tempdir('meta'), 'example.txt');

    let {changed, failed, ok, skipped} = Context.counts;

    await file({
        path,
        state: 'touch',
    });

    let contents = await fs.readFile(path, 'utf8');

    expect.equal(contents, '');

    expect.equal(Context.counts.changed, changed + 1);
    expect.equal(Context.counts.failed, failed);
    expect.equal(Context.counts.ok, ok);
    expect.equal(Context.counts.skipped, skipped);

    //
    // 2. Touch an existing entity.
    //

    const now = Date.now();
    const recent = now - 3_600_000; // An hour ago.

    await fs.utimes(path, recent, recent);

    ({changed, failed, ok, skipped} = Context.counts);

    await file({
        path,
        state: 'touch',
    });

    expect.equal(Context.counts.changed, changed + 1);
    expect.equal(Context.counts.failed, failed);
    expect.equal(Context.counts.ok, ok);
    expect.equal(Context.counts.skipped, skipped);

    const stats = await fs.stat(path);

    // Assert that mtime is within 1 second, allowing some imprecision.
    expect.ok(Math.abs(stats.mtimeMs - now) < 1_000);
});

task("don't notify a handler", async () => {
    await command('mkdir', ['/etc'], {
        creates: '/etc',
        notify: 'should not to be called',
    });
});

task('notify a handler', async () => {
    await command('true', [], {
        notify: 'handle command',
    });
});

handler('should not to be called', async () => {
    fail('handler fired');
});

handler('handle command', async () => {
    await command('true', []);
});
