import ErrorWithMetadata from '../ErrorWithMetadata.js';
import Context from '../Fig/Context.js';
import {log} from '../console/index.js';
import run from '../run.js';
import stringify from '../stringify.js';

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

    log.debug(`Removing: ${args.join(' ')}`);

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
