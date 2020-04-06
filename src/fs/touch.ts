import ErrorWithMetadata from '../ErrorWithMetadata';
import Context from '../Fig/Context';
import {log} from '../console';
import run from '../run';
import stringify from '../stringify';

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
