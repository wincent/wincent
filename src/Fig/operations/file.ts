import * as fs from 'fs';

import {log} from '../../console';
import expand from '../../expand';
import Context from '../Context';

// TODO decide whether we want a separate "directory" operation
// TODO: implement auto-expand of ~
export default async function file({
  force,
  mode,
  path,
  src,
  state,
}: {
  path: string;
  mode?: string;
  src?: string;
  state: 'directory' | 'file' | 'link' | 'touch';
  force?: boolean;
}): Promise<void> {
  if (state === 'directory') {
    directory(path);
  }
}

function directory(path: string) {
  const target = expand(path);

  // TODO: find out if ansible replaces regular file with dir or just errors?
  // TODO: actually throw for errors
  if (fs.existsSync(target)) {
    try {
      const stat = fs.statSync(target);

      if (stat.isDirectory()) {
        Context.informOk(`directory ${path}`);
      } else {
        log.error(`${path} already exists but is not a directory`);
      }
    } catch (error) {
      log.error(`failed to stat: ${path}`);
    }
  } else {
    Context.informChanged(`directory ${path}`);
    fs.mkdirSync(target, {recursive: true});
  }
}
