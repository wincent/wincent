import {default as command} from './Fig/operations/command';
import {default as task} from './Fig/task';
import {default as file} from './Fig/operations/file';
import * as path from './Fig/path';
import {default as root} from './Fig/root';
import {default as variable} from './Fig/variable';

export {command};
export {file};
export {task};
export {path};
export {root};
export {variable};

export interface Fig {
  command: typeof command,
  file: typeof file,
  path: typeof path,
  root: typeof root,
  task: typeof task,
  variable: typeof variable,
}
