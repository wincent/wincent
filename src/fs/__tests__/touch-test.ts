import {join} from 'path';
import assert from '../../assert';
import {expect, test} from '../../test/harness';
import stat from '../stat';
import tempdir from '../tempdir';
import touch from '../touch';

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
