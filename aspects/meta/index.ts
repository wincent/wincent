import * as assert from 'assert';
import {promises as fs} from 'fs';
import {join} from 'path';

import {resource, task, template} from '../../src/Fig/index.js';
import Context from '../../src/Fig/Context.js';
import tempdir from '../../src/fs/tempdir.js';

// TODO: decide whether these should be tests... maybe they should be?
task('template a file', async () => {
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

    const contents = await fs.readFile(path, 'utf8');

    assert.equal(contents, 'Hello Bob, Jane!\n');

    assert.equal(Context.counts.changed, changed + 1);
    assert.equal(Context.counts.failed, failed);
    assert.equal(Context.counts.ok, ok);
    assert.equal(Context.counts.skipped, skipped);

    ({changed, failed, ok, skipped} = Context.counts);

    await template({
        path,
        src: resource.template('sample.txt.erb'),
        variables: {
            greeting: 'Hello',
            names: ['Bob', 'Jane'],
        },
    });

    assert.equal(Context.counts.changed, changed);
    assert.equal(Context.counts.failed, failed);
    assert.equal(Context.counts.ok, ok + 1);
    assert.equal(Context.counts.skipped, skipped);
});
