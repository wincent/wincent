import ErrorWithMetadata from '../ErrorWithMetadata';
import Context from '../Fig/Context';
import {log} from '../console';
import run from '../run';
import stringify from '../stringify';

type Options = {
    mode?: Mode;
    sudo?: boolean;
};

export default async function mkdir(
    path: string,
    options: Options = {}
): Promise<Error | null> {
    const args = [path];

    if (options.mode) {
        args.unshift('-m', options.mode);
    }

    const passphrase = options.sudo ? await Context.sudoPassphrase : undefined;

    const result = await run('mkdir', args, {passphrase});

    if (result.status === 0) {
        return null;
    } else {
        log.debug(stringify(result));

        return (
            result.error ||
            new ErrorWithMetadata(`\`mkdir ${args.join(' ')}\` failed`)
        );
    }
}
