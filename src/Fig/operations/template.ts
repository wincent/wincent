import Context from '../Context';
import file from './file';

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
    const contents = (await Context.compile(src)).fill({variables});

    return await file({
        contents,
        force,
        group,
        mode,
        owner,
        path,
        state: 'file',
    });
}
