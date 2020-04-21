import {join} from 'path';
import assert from '../../assert.js';
import {expect, test} from '../../test/harness.js';
import chmod from '../chmod.js';
import rm from '../rm.js';
import stat from '../../fs/stat.js';
import tempdir from '../../fs/tempdir.js';
import tempfile from '../../fs/tempfile.js';
import touch from '../touch.js';

test('rm() removes a file', async () => {
    const path = await tempfile('rm-test');

    let stats = await stat(path);

    assert(stats !== null);
    assert(!(stats instanceof Error));

    const result = await rm(path);

    expect(result).toBe(null);

    stats = await stat(path);

    expect(stats).toBe(null);
});

test('rm() removes a file, ignoring permissions', async () => {
    const path = await tempfile('rm-test');

    let result = await chmod('0400', path);

    let stats = await stat(path);

    assert(stats !== null);
    assert(!(stats instanceof Error));

    expect(stats.mode).toBe('0400');

    result = await rm(path);

    expect(result).toBe(null);

    stats = await stat(path);

    expect(stats).toBe(null);
});

test('rm() with `recurse: true` removes an empty directory', async () => {
    const path = await tempdir('rm-test');

    let stats = await stat(path);

    assert(stats !== null);
    assert(!(stats instanceof Error));

    const result = await rm(path, {recurse: true});

    expect(result).toBe(null);

    stats = await stat(path);

    expect(stats).toBe(null);
});

test('rm() with `recurse: true` removes a non-empty directory', async () => {
    const path = await tempdir('rm-test');

    let stats = await stat(path);

    assert(stats !== null);
    assert(!(stats instanceof Error));

    const file = join(path, 'file');

    await touch(file);

    stats = await stat(file);

    assert(stats !== null);
    assert(!(stats instanceof Error));

    expect(stats.type).toBe('file');

    const result = await rm(path, {recurse: true});

    expect(result).toBe(null);

    stats = await stat(path);

    expect(stats).toBe(null);
});

test('rm() without `recurse: true` does not remove a directory', async () => {
    const path = await tempdir('rm-test');

    let stats = await stat(path);

    assert(stats !== null);
    assert(!(stats instanceof Error));

    const result = await rm(path);

    expect(result instanceof Error).toBe(true);

    stats = await stat(path);

    assert(stats !== null);
    assert(!(stats instanceof Error));
});
