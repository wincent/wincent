import ErrorWithMetadata from '../ErrorWithMetadata';
import Context from '../Fig/Context';
import {log} from '../console';
import run from '../run';
import stringify from '../stringify';

type Options = {
    sudo?: boolean;
};

export default async function cp(
    source: string,
    target: string,
    options: Options = {}
): Promise<Error | null> {
    const passphrase = options.sudo ? await Context.sudoPassphrase : undefined;

    // TODO: consider passing -f here
    const result = await run('cp', [source, target], {passphrase});

    if (result.status === 0) {
        return null;
    } else {
        log.debug(stringify(result));

        return (
            result.error ||
            new ErrorWithMetadata(`\`cp ${source} ${target}\` failed`)
        );
    }
}
