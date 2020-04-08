import {default as command} from './operations/command.js';
import {default as file} from './operations/file.js';
import * as resource from './resource.js';
import {default as root} from './root.js';
import {default as task} from './task.js';
import {default as template} from './operations/template.js';
import {default as variable} from './variable.js';

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
