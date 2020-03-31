import * as fs from 'fs';

import ErrorWithMetadata from '../../ErrorWithMetadata';
import {log} from '../../console';
import expand from '../../expand';
import run from '../../run';
import stat from '../../stat';
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

  log.info(`template ${src} -> ${target}`);

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

  console.log(diff);

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

    // chown in node works with numeric uid and gid
  } else {
    // open, write, mode
    // can't chown, i think? without uid and gid

    // TODO extract this somewhere else
    // need low-level filesystem ops that are consumed by the high-level
    // user-accessible ops
    let current;

    if (fs.existsSync(target)) {
      current = fs.readFileSync(target, 'utf8');

      if (current !== contents) {
        log.info('change!');
      } else {
        log.info('no change');
      }
    }
  }
}
