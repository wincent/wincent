import {default as attributes} from './Fig/attributes.js';
import {default as command} from './Fig/operations/command.js';
import {default as file} from './Fig/operations/file.js';
import * as resource from './Fig/resource.js';
import {default as root} from './Fig/root.js';
import {default as skip} from './Fig/skip.js';
import {default as task} from './Fig/task.js';
import {default as template} from './Fig/operations/template.js';
import {default as variable} from './Fig/variable.js';
import {default as variables} from './Fig/variables.js';

export {attributes};
export {command};
export {file};
export {resource};
export {root};
export {skip};
export {task};
export {template};
export {variable};
export {variables};

export interface Fig {
    attributes: typeof attributes;
    command: typeof command;
    file: typeof file;
    resource: typeof resource;
    root: typeof root;
    skip: typeof skip;
    task: typeof task;
    template: typeof template;
    variable: typeof variable;
    variables: typeof variables;
}
