import assert from '../../assert';
import {expect, test} from '../../test/harness';
import chmod from '../chmod';
import stat from '../stat';
import tempdir from '../tempdir';
import tempfile from '../tempfile';

test('chmod() changes the mode of a file', async () => {
    const path = await tempfile('chmod-test');

    let stats = await stat(path);

    assert(stats !== null);
    assert(!(stats instanceof Error));

    expect(stats.mode).toBe('0644');

    const result = await chmod('0600', path);

    expect(result).toBe(null);

    stats = await stat(path);

    assert(stats !== null);
    assert(!(stats instanceof Error));

    expect(stats.mode).toBe('0600');
});

test('chmod() changes the mode of a directory', async () => {
    const path = await tempdir('chmod-test');

    let stats = await stat(path);

    assert(stats !== null);
    assert(!(stats instanceof Error));

    expect(stats.mode).toBe('0755');

    const result = await chmod('0700', path);

    expect(result).toBe(null);

    stats = await stat(path);

    assert(stats !== null);
    assert(!(stats instanceof Error));

    expect(stats.mode).toBe('0700');
});
