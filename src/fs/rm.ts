import ErrorWithMetadata from '../ErrorWithMetadata';
import Context from '../Fig/Context';
import {log} from '../console';
import run from '../run';
import stringify from '../stringify';

type Options = {
    recurse?: boolean;
    sudo?: boolean;
};

export default async function rm(
    path: string,
    options: Options = {}
): Promise<Error | null> {
    const passphrase = options.sudo ? await Context.sudoPassphrase : undefined;

    const args = ['-f', path];

    if (options.recurse) {
        args.unshift('-r');
    }

    const result = await run('rm', args, {passphrase});

    if (result.status === 0) {
        return null;
    } else {
        log.debug(stringify(result));

        return (
            result.error ||
            new ErrorWithMetadata(`\`rm ${args.join(' ')}\` failed`)
        );
    }
}
