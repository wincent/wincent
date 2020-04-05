import ErrorWithMetadata from '../../ErrorWithMetadata';
import chown from '../../chown';
import {log} from '../../console';
import expand from '../../expand';
import tempfile from '../../tempfile';
import Context from '../Context';
import compare from '../compare';

export default async function template({
    force,
    group,
    mode,
    owner,
    path,
    src,
    variables = {},
}: {
    force?: boolean;
    group?: string;
    path: string;
    mode?: Mode;
    owner?: string;
    src: string;
    variables: Variables;
}): Promise<void> {
    const target = expand(path);

    const contents = (await Context.compile(src)).fill({variables});

    const diff = await compare({
        contents,
        force,
        group,
        mode,
        owner,
        path: target,
        state: 'file',
    });

    if (diff.state === 'file') {
        // TODO: file does not exist — have to create it
    } else if (diff.owner || diff.group) {
        const result = await chown(target, {group, owner, sudo: true});

        if (result instanceof Error) {
            throw new ErrorWithMetadata(`Failed command`, {
                error: result.toString(),
                group: group ?? null,
                owner: owner ?? null,
                target,
            });
        }
    } else {
        if (diff.contents) {
            // log.info('change!');
            const temp = await tempfile(contents);
            log.debug(`Wrote to temporary file: ${temp}`);

            // TODO: cp from temp to target
            // TODO: deal with group/owner/mode etc
        } else {
            Context.informOk(`template ${path}`);
        }
    }
}
