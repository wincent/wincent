import {default as command} from './operations/command';
import {default as file} from './operations/file';
import * as resource from './resource';
import {default as root} from './root';
import {default as task} from './task';
import {default as template} from './operations/template';
import {default as variable} from './variable';

export {command};
export {file};
export {resource};
export {root};
export {task};
export {template};
export {variable};

export interface Fig {
  command: typeof command;
  file: typeof file;
  resource: typeof resource;
  root: typeof root;
  task: typeof task;
  template: typeof template;
  variable: typeof variable;
}
