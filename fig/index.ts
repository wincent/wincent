// TODO: maybe make a "register" function for arbitrary communication/sharing
// across tasks/aspects

//
// Main DSL
//

export {default as attributes} from './dsl/attributes.js';
export {default as backup} from './dsl/operations/backup.js';
export {default as fail} from './dsl/fail.js';
export {default as command} from './dsl/operations/command.js';
export {default as cron} from './dsl/operations/cron.js';
export {default as defaults} from './dsl/operations/defaults.js';
export {default as fetch} from './dsl/operations/fetch.js';
export {default as file} from './dsl/operations/file.js';
export {default as handler} from './dsl/handler.js';
export {default as line} from './dsl/operations/line.js';
export {default as options} from './dsl/options.js';
export {default as template} from './dsl/operations/template.js';
export * as resource from './dsl/resource.js';
export {default as root} from './dsl/root.js';
export {default as skip} from './dsl/skip.js';
export {default as task} from './dsl/task.js';
export {default as variable} from './dsl/variable.js';
export {default as variables} from './dsl/variables.js';

//
// Other useful functions for use in aspects.
//

export type {Path} from './path.js';

export {log} from './console.js';
export {default as path} from './path.js';
export {default as prompt} from './prompt.js';

// Re-export project-local helpers.

export * as helpers from '../helpers.js';
