import {join} from 'path';
import assert from '../../assert.js';
import {expect, test} from '../../test/harness.js';
import stat from '../stat.js';
import tempdir from '../tempdir.js';
import touch from '../touch.js';

test('touch() creates a file', async () => {
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
});
