import ErrorWithMetadata from './ErrorWithMetadata.js';
import {spawnSync} from './child_process.js';

/**
 * For the benefit of the `Attributes` class, we want a synchronous way
 * of looking up group information from /etc/group. We use this because
 * we need symbolic names and not the numeric group IDs provided by
 * `process.getgid()` and `process.getgroups()`.
 *
 * This function can fill in for `id -Gn` (which returns all group names
 * related to the current user) and for `id -rgn` (which returns the
 * principal, "real" group name of the current user): it always returns
 * all group names, but by convention returns the principal group as the
 * first.
 */
export default function id(): Array<string> {
    const groups = run('-Gn').split(/\s+/);

    const group = run('-rgn');

    // Normally, `group` will be first item in `groups` anyway, but make sure:
    return [group, ...groups.filter((g) => g !== group)];
}

function run(...args: Array<string>): string {
    const {error, signal, status, stderr, stdout} = spawnSync('id', args, {
        encoding: 'utf8',
    });

    if (status === 0) {
        return stdout.trim();
    }

    throw new ErrorWithMetadata(`Failed to run \`id ${args.join(' ')}\``, {
        error: error?.toString() ?? null,
        signal,
        status,
        stderr,
        stdout,
    });
}
