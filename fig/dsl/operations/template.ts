import Context from '../../Context.js';
import {LAQUO, RAQUO} from '../../Unicode.js';
import {default as toPath} from '../../path.js';
import file from './file.js';

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
  notify?: string;
  owner?: string;
  src: string;
  sudo?: boolean;
  variables?: Variables;
}): Promise<void> {
  const {figManaged} = variables;

  const contents = (await Context.compile(src)).fill({
    variables: {
      ...variables,
      figManaged:
        typeof figManaged === 'string'
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
