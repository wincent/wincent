import Context from '../Context.js';
import ErrorWithMetadata from '../ErrorWithMetadata.js';
import {log} from '../console.js';
import run from '../run.js';
import stringify from '../stringify.js';

type Options = {
    sudo?: boolean;
};

export default async function cp(
    source: string,
    target: string,
    options: Options = {}
): Promise<Error | null> {
    const passphrase = options.sudo ? await Context.sudoPassphrase : undefined;

    log.debug(`Copying: ${source} ${target}`);

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
