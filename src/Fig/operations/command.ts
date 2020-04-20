import ErrorWithMetadata from '../../ErrorWithMetadata.js';
import {debug, log} from '../../console/index.js';
import path from '../../path.js';
import spawn from '../../spawn.js';
import stringify from '../../stringify.js';
import stat from '../../fs/stat.js';
import Context from '../Context.js';

/**
 * Implements basic shell expansion (of ~).
 */
export default async function command(
    executable: string,
    args: Array<string>,
    options: {
        chdir?: string;
        creates?: string;
    } = {}
): Promise<void> {
    const description = [executable, ...args].join(' ');

    if (options.creates) {
        const stats = await stat(path(options.creates).expand);

        if (stats instanceof Error) {
            throw stats;
        }

        if (stats !== null) {
            Context.informSkipped(`command \`${description}\``);
            return;
        }
    }

    try {
        log.debug(
            `Run command \`${description}\` with options: ${stringify(options)}`
        );

        await spawn(
            path(executable).expand,
            args.map((arg) => path(arg).expand),
            options.chdir ? {cwd: options.chdir.toString()} : {}
        );

        Context.informChanged(`command \`${description}\``);
    } catch (error) {
        if (error instanceof ErrorWithMetadata) {
            Context.informFailed(error);
        } else {
            debug(() => console.log(error));
            Context.informFailed(`command \`${description}\` failed`);
        }
    }
}
