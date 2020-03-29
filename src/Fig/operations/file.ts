import * as fs from 'fs';

import {log} from '../../console';
import expand from '../../expand';

// TODO decide whether we want a separate "directory" operation
// TODO: implement auto-expand of ~
export default function file({
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
}) {
  log(`file: ${path} -> ${state}`);

  if (state === 'directory') {
    directory(path);
  }
}

function directory(path: string) {
  const target = expand(path);

  // TODO: find out if ansible replaces regular file with dir or just errors?
  if (fs.existsSync(target)) {
    try {
      const stat = fs.statSync(target);

      if (stat.isDirectory()) {
        // TODO: log "ok: ..."
        log.info(`ok: directory ${path}`);
      } else {
        log.error(`${path} already exists but is not a directory`);
      }
    } catch (error) {
      log.error(`failed to stat: ${path}`);
    }
  } else {
    // TODO: decide on who to log this stuff in a standard way
    // ok: ...
    // changed: ...
    // skipping: ...
    // at end:
    // "PLAY RECAP"
    // ok=16 changed=7 unreachable=0 failed=0 skipped=2 rescued=0 ignored=0
    log.notice(`changed: directory ${path}`);
    fs.mkdirSync(target, {recursive: true});
  }
}
