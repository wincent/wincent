import Attributes from '../../Attributes.js';
import assert from '../../assert.js';
import stat from '../../fs/stat.js';
import tempdir from '../../fs/tempdir.js';
import tempfile from '../../fs/tempfile.js';
import {expect, test} from '../../test/harness.js';
import chmod from '../chmod.js';

const umask = new Attributes().umask;

test('chmod() changes the mode of a file', async () => {
    const path = await tempfile('chmod-test');

    let stats = await stat(path);

    assert(stats !== null);
    assert(!(stats instanceof Error));

    // If umask is 0022, expected mode is 0644.
    // If umask is 0002, expected mode is 0664.
    const mode = (0o666 - parseInt(umask, 8)).toString(8).padStart(4, '0');

    expect(stats.mode).toBe(mode);

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

    // If umask is 0022, expected mode is 0755.
    // If umask is 0002, expected mode is 0775.
    const mode = (0o777 - parseInt(umask, 8)).toString(8).padStart(4, '0');

    expect(stats.mode).toBe(mode);

    const result = await chmod('0700', path);

    expect(result).toBe(null);

    stats = await stat(path);

    assert(stats !== null);
    assert(!(stats instanceof Error));

    expect(stats.mode).toBe('0700');
});
