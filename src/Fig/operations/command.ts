import ErrorWithMetadata from '../../ErrorWithMetadata.js';
import expand from '../../path/expand.js';
import spawn from '../../spawn.js';
import Context from '../Context.js';

/**
 * Implements basic shell expansion (of ~).
 */
export default async function command(
    executable: string,
    ...args: Array<string>
): Promise<void> {
    const description = [executable, ...args].join(' ');

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
