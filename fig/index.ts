import {default as attributes} from './dsl/attributes.js';
import {default as command} from './dsl/operations/command.js';
import {default as file} from './dsl/operations/file.js';
import {default as template} from './dsl/operations/template.js';
import * as resource from './dsl/resource.js';
import {default as root} from './dsl/root.js';
import {default as skip} from './dsl/skip.js';
import {default as task} from './dsl/task.js';
import {default as variable} from './dsl/variable.js';
import {default as variables} from './dsl/variables.js';

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
