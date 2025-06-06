import Context from '../../Context.ts';
import {LAQUO, RAQUO} from '../../Unicode.ts';
import {default as toPath} from '../../path.ts';
import file from './file.ts';

export default async function template({
  force,
  group,
  mode,
  notify,
  owner,
  path,
  src,
  sudo,
  variables = Context.currentVariables,
}: {
  force?: boolean;
  group?: string;
  path: string;
  mode?: Mode;
  notify?: Array<string> | string;
  owner?: string;
  src: string;
  sudo?: boolean;
  variables?: Variables;
}): Promise<OperationResult> {
  const {figManaged} = variables;

  const contents = (await Context.compile(src)).fill({
    variables: {
      ...variables,
      figManaged: typeof figManaged === 'string'
        ? figManaged.replace(`${LAQUO}file${RAQUO}`, toPath(src).resolve)
        : '',
    },
  });

  return await file({
    contents,
    force,
    group,
    mode,
    notify,
    owner,
    path,
    state: 'file',
    sudo,
  });
}
