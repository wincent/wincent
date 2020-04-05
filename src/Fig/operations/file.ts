import {promises as fs} from 'fs';

import ErrorWithMetadata from '../../ErrorWithMetadata';
import expand from '../../expand';
import stat from '../../stat';
import Context from '../Context';

// TODO decide whether we want a separate "directory" operation
export default async function file({
    force,
    mode,
    path,
    src,
    state,
}: {
    path: string;
    mode?: Mode;
    src?: string;
    state: 'directory' | 'file' | 'link' | 'touch';
    force?: boolean;
}): Promise<void> {
    if (state === 'directory') {
        await directory(path);
    }

    // TODO: probably refactor this to use compare.ts
    if (0) {
        // In the meantime, silence unused parameter warnings.
        console.log(force, mode, src);
    }
}

async function directory(path: string) {
    const target = expand(path);

    const stats = await stat(target);

    if (stats instanceof Error) {
        throw stats;
    } else if (stats === null) {
        Context.informChanged(`directory ${path}`);
        await fs.mkdir(target, {recursive: true});
    } else if (stats.type === 'directory') {
        // TODO: check ownership, perms etc
        Context.informOk(`directory ${path}`);
    } else {
        // TODO: find out if ansible replaces regular file with dir or just errors?
        throw new ErrorWithMetadata(
            `${path} already exists but is not a directory`
        );
    }
}
