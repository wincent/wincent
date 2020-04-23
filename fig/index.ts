// TODO: maybe make a "register" function for arbitrary communication/sharing
// across tasks/aspects
// TODO: export "path" here for convenience? it is very DSL-ish
export {default as attributes} from './dsl/attributes.js';
export {default as command} from './dsl/operations/command.js';
export {default as fetch} from './dsl/operations/fetch.js';
export {default as file} from './dsl/operations/file.js';
export {default as template} from './dsl/operations/template.js';
export * as resource from './dsl/resource.js';
export {default as root} from './dsl/root.js';
export {default as skip} from './dsl/skip.js';
export {default as task} from './dsl/task.js';
export {default as variable} from './dsl/variable.js';
export {default as variables} from './dsl/variables.js';
