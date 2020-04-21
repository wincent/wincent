import Context from '../Context.js';
import ErrorWithMetadata from '../ErrorWithMetadata.js';
import run from '../run.js';

type Stats = {
    group: string;
    mode: Mode;
    target?: string;
    type: 'directory' | 'file' | 'link' | 'socket' | 'special' | 'unknown';
    owner: string;
};

const TYPE_MAP = {
    'character device': 'special',
    'character special file': 'special',
    directory: 'directory',
    'regular file': 'file',
    socket: 'socket',
    'symbolic link': 'link',
} as const;

/**
 * Wrapper for "stat" command.
 *
 * Ideally, we'd just use `fs.stat`, but the trouble with that is we can't rely
 * on it to stat root-owned files; we need to be able to run a separate too,
 * with `sudo` if necessary.
 */
export default async function stat(
    path: string
): Promise<Error | Stats | null> {
    if (Context.attributes.platform === 'darwin') {
        const formats = {
            group: '%Sg',
            mode: '%Lp',
            newline: '%n',
            target: '%Y',
            type: '%HT',
            owner: '%Su',
        };

        const formatString = [
            formats.mode,
            formats.type,
            formats.owner,
            formats.group,
            formats.target,
        ].join(formats.newline);

        // Try without sudo, then with.
        for (const sudo of [false, true]) {
            const options = sudo
                ? {passphrase: await Context.sudoPassphrase}
                : undefined;

            const {status, stderr, stdout} = await run(
                'stat',
                ['-f', formatString, path],
                options
            );

            if (status === 0) {
                const [mode, type, owner, group, target] = stdout.split('\n');

                const paddedMode = mode.padStart(4, '0');

                assertMode(paddedMode);

                return {
                    group,
                    mode: paddedMode,
                    target: target || undefined,
                    type: (TYPE_MAP as any)[type.toLowerCase()] || 'unknown',
                    owner,
                };
            }

            if (/no such file/i.test(stderr)) {
                return null;
            } else if (!/permission denied/i.test(stderr)) {
                // Give up...
                break;
            }
        }
    } else {
        throw new Error('TODO: implement');
        // GNU: command stat --printf '%a\n%F\n%G\n%U\n'
        // a = mode
        // F = type
        // G = group name
        // U = owner name
        // maybe %N (link target): prints 'src' -> 'target'
        // 644, 1777
        // regular file, directory, symbolic link, character special file
    }

    return new ErrorWithMetadata(`Unable to stat ${path}`);
}

const MODE_REGEXP = /^0[0-7]{3}$/;

function assertMode(mode: string): asserts mode is Mode {
    if (!MODE_REGEXP.test(mode)) {
        throw new Error(`Invalid mode ${mode}`);
    }
}
