import ErrorWithMetadata from '../../ErrorWithMetadata';
import {log} from '../../console';
import chown from '../../fs/chown';
import mkdir from '../../fs/mkdir';
import expand from '../../path/expand';
import tempfile from '../../tempfile';
import Context from '../Context';
import compare from '../compare';

export default async function file({
    contents,
    force,
    group,
    mode,
    owner,
    path,
    src,
    state,
}: {
    contents?: string;
    force?: boolean;
    group?: string;
    path: string;
    mode?: Mode;
    owner?: string;
    src?: string;
    state: 'directory' | 'file' | 'link' | 'touch';
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

    if (state === 'directory') {
        if (diff.state === 'directory') {
            // TODO: if force in effect, that means we have to remove file/link
            // first.
            const sudo = !!(diff.owner || diff.group);
            const result = await mkdir(target, {mode, sudo});

            if (result instanceof Error) {
                throw result;
            }

            Context.informChanged(`directory ${path}`);
        } else {
            // Already a directory.
            Context.informOk(`directory ${path}`);
            // TODO still check ownership, perms etc
        }
    } else if (state === 'file') {
        if (diff.state === 'file') {
            // TODO: file does not exist — have to create it
            // if contents, use that
            // if src, copy that
            // if neither, create empty
        }

        if (diff.owner || diff.group) {
            const result = await chown(target, {group, owner, sudo: true});

            if (result instanceof Error) {
                throw result;
            }
        }

        if (diff.contents) {
            // log.info('change!');
            if (src) {
                // just copy from src
            } else {
                const temp = await tempfile(diff.contents);
                log.debug(`Wrote to temporary file: ${temp}`);
            }

            // TODO: cp from temp to target
            // TODO: deal with group/owner/mode etc
        }

        // BUG: we use "template" here; not distinguishing between
        // "template" and "file"
        Context.informOk(`template ${path}`);
    } else if (state === 'link') {
        // TODO
    } else if (state === 'touch') {
        // TODO
    } else {
        throw new Error('Unreachable');
    }

    // TODO: probably refactor this to use compare.ts
    if (0) {
        // In the meantime, silence unused parameter warnings.
        console.log(force, mode, src);
    }
}
