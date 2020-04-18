import * as expect from 'assert';
import {promises as fs} from 'fs';
import {join} from 'path';

import {file, resource, task, template} from '../../src/Fig/index.js';
import Context from '../../src/Fig/Context.js';
import assert from '../../src/assert.js';
import stat from '../../src/fs/stat.js';
import tempdir from '../../src/fs/tempdir.js';

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

task('create a directory', async () => {});

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

    let stats = await stat(path);

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

    stats = await stat(path);

    assert(stats && !(stats instanceof Error));

    expect.equal(stats.mode, '0644');
});
