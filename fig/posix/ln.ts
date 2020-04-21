import Context from '../Context.js';
import ErrorWithMetadata from '../ErrorWithMetadata.js';
import {log} from '../console.js';
import run from '../run.js';
import stringify from '../stringify.js';

type Options = {
    force?: boolean;
    sudo?: boolean;
    // TODO: consider adding support for hardlinks too
};

export default async function ln(
    source: string,
    target: string,
    options: Options = {}
): Promise<Error | null> {
    const passphrase = options.sudo ? await Context.sudoPassphrase : undefined;

    const args = [options.force ? '-sfn' : '-sn', source, target];

    log.debug(`Linking: ${args.join(' ')}`);

    const result = await run('ln', args, {passphrase});

    if (result.status === 0) {
        return null;
    } else {
        log.debug(stringify(result));

        return (
            result.error ||
            new ErrorWithMetadata(`\`ln ${args.join(' ')}\` failed`)
        );
    }
}
