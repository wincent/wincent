import ErrorWithMetadata from '../ErrorWithMetadata';
import Context from '../Fig/Context';
import {log} from '../console';
import run from '../run';
import stringify from '../stringify';

type Options = {
    sudo?: boolean;
};

export default async function chmod(
    mode: Mode,
    path: string,
    options: Options = {}
): Promise<Error | null> {
    const passphrase = options.sudo ? await Context.sudoPassphrase : undefined;

    const args = [mode, path];

    const result = await run('chmod', args, {passphrase});

    if (result.status === 0) {
        return null;
    } else {
        log.debug(stringify(result));

        return (
            result.error ||
            new ErrorWithMetadata(`\`chmod ${args.join(' ')}\` failed`)
        );
    }
}
