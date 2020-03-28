import * as fs from 'fs';
import {join, parse, sep} from 'path';

import Context from '../Context';
import {log} from '../../console';

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
  const {root} = parse(target);

  // Instead of doing a naive split, which would yield something like:
  //
  //    '', 'a', 'b', 'c'
  //
  // We pull off the root, and then stick it back on in our `reduce()`
  // call so as to obtain:
  //
  //    '/', 'a', 'b', 'c'
  //
  // When we `join` successively, we'll get "/", then "/a", then "/a/b"
  // etc.
  const components = target.slice(root.length).split(sep);

  components.reduce((current, component, i) => {
    if (current === '') {
      // Something went wrong on a previous iteration.
      return '';
    }

    const next = join(current, component);
    const isLast = i === components.length - 1;

    if (fs.existsSync(next)) {
      try {
        const stat = fs.statSync(next);

        if (!stat.isDirectory()) {
          log.error(
            `cannot create directory ${target} at non-directory ${next}`
          );
          return '';
        }
      } catch (error) {
        log.error(`failed to stat: ${next}`);
        return '';
      }

      if (isLast) {
        log.info(`exists: ${next}`);
      }

      return next;
    } else {
      log.info(`creating: ${next}`);
      // TODO: actually create
    }

    return next;
  }, root);
}

function expand(path: string) {
  if (path.startsWith('~/')) {
    return join(Context.attributes.homedir, path.slice(2));
  }

  return path;
}
