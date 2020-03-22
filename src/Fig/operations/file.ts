import {log} from '../../console';

// TODO decide whether we want a separate "directory" operation
export default function file({
  force,
  mode,
  path,
  src,
  state,
} : {
  path: string,
  mode?: string,
  src?: string,
  state: 'directory' | 'file' | 'link' | 'touch',
  force?: boolean
}) {
  log(`file: ${path} -> ${state}`);
}
