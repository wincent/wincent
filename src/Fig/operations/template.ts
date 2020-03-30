import * as fs from 'fs';

import ErrorWithMetadata from '../../ErrorWithMetadata';
import {log} from '../../console';
import expand from '../../expand';
import sudo from '../../sudo';
import {compile, fill} from '../../template';
import Context from '../Context';

export default async function template({
  group,
  mode,
  owner,
  path,
  src,
  variables = {},
}: {
  group?: string;
  path: string;
  mode?: string;
  owner?: string;
  src: string;
  variables: Variables;
}): Promise<void> {
  const target = expand(path);
  log.info(`template ${src} -> ${target}`);

  const filled = (await Context.compile(src)).fill({variables});

  if (owner && owner !== Context.attributes.username) {
    log.notice(`needs sudo: ${Context.attributes.username} -> ${owner}`);
    const passphrase = await Context.sudoPassphrase;
    const result = await sudo('ls', ['-l', '/var/audit'], {passphrase});

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
    let contents;

    if (fs.existsSync(target)) {
      contents = fs.readFileSync(target, 'utf8');

      if (contents !== filled) {
        log.info('change!');
      } else {
        log.info('no change');
      }
    }
  }
}
