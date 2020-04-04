import ErrorWithMetadata from './ErrorWithMetadata';
import Context from './Fig/Context';
import run from './run';

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
        // With or without `sudo` (in practice, if we are calling `chown()` at
        // all, it will probably be with `sudo`).
        //
        const passphrase = options.sudo ? (await Context.sudoPassphrase) : undefined;

        let ownerAndGroup = options.owner || '';

        if (options.group) {
            ownerAndGroup += `:${options.group}`;
        }

        const result = await run('chown', [ownerAndGroup, path], {passphrase});

        if (result.status === 0) {
            return null;
        } else {
            return result.error || new ErrorWithMetadata('chown failed');
        }
    } else {
        throw new Error('TODO: implement');
    }
}
