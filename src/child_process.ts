/**
 * @file
 *
 * Wrappers for Node "child_process" module methods that convert `Path`
 * string-like objects to strings before calling the underlying method.
 */

import * as child_process from 'child_process';

// TODO: see if I can do this with a few less "any"; necessary because there are
// so many overloads of these functions.

const spawn: typeof child_process.spawn = ((
    command: any,
    args: any,
    options: any
) => {
    return child_process.spawn(command.toString(), args, options);
}) as any;

export {spawn};

const spawnSync: typeof child_process.spawnSync = ((
    command: any,
    args: any,
    options: any
): any => {
    return child_process.spawnSync(command.toString(), args, options);
}) as any;

export {spawnSync};
