import * as fs from 'fs';

import ErrorWithMetadata from '../../ErrorWithMetadata';
import {log} from '../../console';
import expand from '../../expand';
import run from '../../run';
import tempfile from '../../tempfile';
import {compile, fill} from '../../template';
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

  if (owner && owner !== Context.attributes.username) {
    log.notice(`needs sudo: ${Context.attributes.username} -> ${owner}`);
    const passphrase = await Context.sudoPassphrase;
    const result = await run('ls', ['-l', '/var/audit'], {passphrase});

    if (result.status !== 0) {
      throw new ErrorWithMetadata(`Failed command`, {
        ...result,
        error: result.error?.toString() ?? null,
      });
    }
  } else {
    if (diff.contents) {
      log.info('change!');
      const temp = await tempfile(contents);

      // TODO: cp from temp to target
      // TODO: deal with group/owner/mode etc
    } else {
      Context.informOk(`template ${path}`);
    }
  }
}
