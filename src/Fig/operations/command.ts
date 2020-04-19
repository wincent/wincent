import ErrorWithMetadata from '../../ErrorWithMetadata.js';
import expand from '../../path/expand.js';
import spawn from '../../spawn.js';
import stat from '../../fs/stat.js';
import Context from '../Context.js';

/**
 * Implements basic shell expansion (of ~).
 */
export default async function command(
    executable: string,
    args: Array<string>,
    options: {
        creates?: string;
    } = {}
): Promise<void> {
    const description = [executable, ...args].join(' ');

    if (options.creates) {
        const stats = await stat(expand(options.creates));

        if (stats instanceof Error) {
            throw stats;
        }

        if (stats !== null) {
            Context.informSkipped(`command \`${description}\``);
            return;
        }
    }

    try {
        await spawn(expand(executable), ...args.map(expand));
        // TODO: decide whether to log full command here
        Context.informChanged(`command \`${description}\``);
    } catch (error) {
        if (error instanceof ErrorWithMetadata) {
            Context.informFailed(error);
        } else {
            Context.informFailed(`command \`${description}\` failed`);
        }
    }
}
