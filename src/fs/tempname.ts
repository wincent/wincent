import {randomBytes} from 'crypto';
import {tmpdir} from 'os';
import {join} from 'path';

const COUNTERS: {[prefix: string]: number} = {};

const TMP_DIR = tmpdir();

export default function tempname(prefix: string) {
    COUNTERS[prefix] = Number(COUNTERS[prefix] || 0) + 1;

    const name = `${prefix}-${COUNTERS[prefix]
        .toString(10)
        .padStart(4, '0')}-${randomBytes(16).toString('hex')}`;

    return join(TMP_DIR, name);
}
