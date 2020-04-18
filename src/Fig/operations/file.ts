import ErrorWithMetadata from '../../ErrorWithMetadata.js';
import {log} from '../../console/index.js';
import chmod from '../../fs/chmod.js';
import chown from '../../fs/chown.js';
import cp from '../../fs/cp.js';
import mkdir from '../../fs/mkdir.js';
import tempfile from '../../fs/tempfile.js';
import expand from '../../path/expand.js';
import Context from '../Context.js';
import compare from '../compare.js';

export default async function file({
    contents,
    force,
    group,
    mode,
    owner,
    path,
    src,
    state,
    sudo,
}: {
    contents?: string;
    force?: boolean;
    group?: string;
    path: string;
    mode?: Mode;
    owner?: string;
    src?: string;
    state: 'directory' | 'file' | 'link' | 'touch';
    sudo?: boolean;
}): Promise<void> {
    if (state !== 'file' && (contents !== undefined || src !== undefined)) {
        throw new ErrorWithMetadata(
            `A file-system object cannot have "contents" or "src" unless its state is \`file\``
        );
    }

    if (contents !== undefined && src !== undefined) {
        throw new ErrorWithMetadata(
            `Cannot populate a file-system object with both "contents" and from "src"`
        );
    }

    const target = expand(path);

    if (src) {
        // TODO: read and feed that into contents
    }

    const diff = await compare({
        contents,
        force,
        group,
        mode,
        owner,
        path: target,
        state,
    });

    if (diff.error) {
        // TODO: maybe wrap this to make it more specific
        throw diff.error;
    }

    let changed: Array<string> = [];

    if (state === 'directory') {
        if (diff.state === 'directory') {
            // TODO: if force in effect, that means we have to remove file/link
            // first.
            const result = await mkdir(target, {mode, sudo});

            if (result instanceof Error) {
                throw result;
            }

            changed.push('directory');
        }
    } else if (state === 'file') {
        if (diff.state === 'file') {
            // TODO: file does not exist — have to create it
            // if contents, use that
            // if src, copy that
            // if neither, create empty
        }

        if (diff.owner || diff.group) {
            const result = await chown(target, {group, owner, sudo});

            if (result instanceof Error) {
                throw result;
            }

            if (diff.owner) {
                changed.push('owner');
            }

            if (diff.group) {
                changed.push('group');
            }
        }

        if (diff.contents) {
            // log.info('change!');
            let from;

            if (src) {
                from = src;
            } else {
                from = await tempfile('file', diff.contents);
            }

            log.debug(`Copying form ${from}`);

            const result = await cp(from, target);

            if (result instanceof Error) {
                throw result;
            }

            changed.push('contents');
        }
    } else if (state === 'link') {
        // TODO
    } else if (state === 'touch') {
        // TODO
    } else {
        throw new Error('Unreachable');
    }

    if (diff.mode) {
        const result = await chmod(diff.mode, target, {sudo});

        if (result instanceof Error) {
            throw result;
        }

        changed.push('mode');
    }

    // BUG: we use "file" here; not distinguishing between
    // "template" and "file"
    if (changed.length) {
        Context.informChanged(`file[${changed.join('|')}] ${path}`);
    } else {
        Context.informOk(`file ${path}`);
    }
}
