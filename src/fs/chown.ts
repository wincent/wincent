import ErrorWithMetadata from '../ErrorWithMetadata.js';
import Context from '../Fig/Context.js';
import {log} from '../console.js';
import run from '../run.js';
import stringify from '../stringify.js';

type Options = {
    group?: string;
    sudo?: boolean;
    owner?: string;
};

export default async function chown(
    path: string,
    options: Options = {}
): Promise<Error | null> {
    if (Context.attributes.platform === 'darwin') {
        // Run one of:
        //
        //      chown owner path
        //      chown :group path
        //      chown owner:group path
        //
        // With or without `sudo` (although note that, in practice, if
        // we are calling `chown()` at all, it will probably be with
        // `sudo`).
        //

        let ownerAndGroup = options.owner || '';

        if (options.group) {
            ownerAndGroup += `:${options.group}`;
        }

        const args = [ownerAndGroup, path];

        const passphrase = options.sudo
            ? await Context.sudoPassphrase
            : undefined;

        log.debug(`Setting ownership: ${args.join(' ')}`);

        const result = await run('chown', args, {passphrase});

        if (result.status === 0) {
            return null;
        } else {
            log.debug(stringify(result));

            return (
                result.error ||
                new ErrorWithMetadata(`\`chown ${args.join(' ')}\` failed`)
            );
        }
    } else {
        throw new Error('TODO: implement');
    }
}
