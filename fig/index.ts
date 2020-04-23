import {default as attributes} from './dsl/attributes.js';
import {default as command} from './dsl/operations/command.js';
import {default as fetch} from './dsl/operations/fetch.js';
import {default as file} from './dsl/operations/file.js';
import {default as template} from './dsl/operations/template.js';
import * as resource from './dsl/resource.js';
import {default as root} from './dsl/root.js';
import {default as skip} from './dsl/skip.js';
import {default as task} from './dsl/task.js';
import {default as variable} from './dsl/variable.js';
import {default as variables} from './dsl/variables.js';

// TODO: maybe make a "register" function for arbitrary communication/sharing
// across tasks/aspects
// TODO: export "path" here for convenience? it is very DSL-ish

export {attributes};
export {command};
export {fetch};
export {file};
export {resource};
export {root};
export {skip};
export {task};
export {template};
export {variable};
export {variables};
