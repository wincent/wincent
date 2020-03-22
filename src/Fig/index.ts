import {default as command} from './operations/command';
import {default as task} from './task';
import {default as file} from './operations/file';
import * as path from './path';
import {default as root} from './root';
import {default as variable} from './variable';

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
