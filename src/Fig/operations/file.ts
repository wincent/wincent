import ErrorWithMetadata from '../../ErrorWithMetadata.js';
import {promises as fs} from '../../fs.js';
import chmod from '../../fs/chmod.js';
import chown from '../../fs/chown.js';
import cp from '../../fs/cp.js';
import ln from '../../fs/ln.js';
import mkdir from '../../fs/mkdir.js';
import tempfile from '../../fs/tempfile.js';
import touch from '../../fs/touch.js';
import {default as toPath} from '../../path.js';
import Context from '../Context.js';
import assert from '../../assert.js';
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
    if (contents !== undefined && state !== 'file') {
        throw new ErrorWithMetadata(
            `A file-system object cannot have "contents" unless its state is \`file\``
        );
    }

    if (src !== undefined && !(state === 'file' || state === 'link')) {
        throw new ErrorWithMetadata(
            `A file-system object cannot have "src" unless its state is \`file\` or \`link\``
        );
    }

    if (contents !== undefined && src !== undefined) {
        throw new ErrorWithMetadata(
            `Cannot populate a file-system object with both "contents" and from "src"`
        );
    }

    if (state === 'link' && src === undefined) {
        throw new ErrorWithMetadata(
            `Cannot manage state \`link\` without "src"`
        );
    }

    const target = toPath(path).resolve.toString();

    if (src) {
        src = toPath(src).resolve.toString();
        if (state !== 'link') {
            // TODO: handle edge case that src is root-owned and not readable
            // TODO: overwriting contents here is a smell?
            contents = contents ?? (await fs.readFile(src, 'utf8'));

            // TODO: make fs wrapper(s) that can deal with Path
            // string-likes so that I don't have to deal with these
            // toString() calls
        }
    }

    const diff = await compare({
        contents,
        force,
        group,
        mode,
        owner,
        path: target,
        state,
        target: state === 'link' ? src : undefined,
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
            // File does not exist — have to create it.
            if (typeof contents !== 'string') {
                // No contents, no src, so treat this just like "touch".
                const result = await touch(target, {sudo});

                if (result instanceof Error) {
                    throw result;
                }

                changed.push('create');
            }
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

        if (diff.contents !== undefined) {
            let from;

            if (src) {
                from = src;
            } else {
                from = await tempfile('file', diff.contents);
            }

            const result = await cp(from, target);

            if (result instanceof Error) {
                throw result;
            }

            changed.push('contents');
        }
    } else if (state === 'link') {
        if (diff.state === 'link') {
            assert(src);

            const result = await ln(src, target, {
                force: diff.force,
                sudo,
            });

            if (result instanceof Error) {
                throw result;
            }

            changed.push('link');
        }
    } else if (state === 'touch') {
        const result = await touch(target, {sudo});

        if (result instanceof Error) {
            throw result;
        }

        changed.push('touch');
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
