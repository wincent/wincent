import ErrorWithMetadata from '../ErrorWithMetadata.js';
import Context from '../Fig/Context.js';
import {log} from '../console.js';
import run from '../run.js';
import stringify from '../stringify.js';

type Options = {
    sudo?: boolean;
};

export default async function touch(
    path: string,
    options: Options = {}
): Promise<Error | null> {
    const passphrase = options.sudo ? await Context.sudoPassphrase : undefined;

    // Note: on Linux, the `-f` flag will be ignored.
    const args = ['-f', path];

    log.debug(`Touching: ${args.join(' ')}`);

    const result = await run('touch', args, {passphrase});

    if (result.status === 0) {
        return null;
    } else {
        log.debug(stringify(result));

        return (
            result.error ||
            new ErrorWithMetadata(`\`touch ${args.join(' ')}\` failed`)
        );
    }
}
