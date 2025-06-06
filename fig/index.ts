// TODO: maybe make a "register" function for arbitrary communication/sharing
// across tasks/aspects

//
// Main DSL
//

export {default as attributes} from './dsl/attributes.ts';
export {default as fail} from './dsl/fail.ts';
export {default as handler} from './dsl/handler.ts';
export {default as backup} from './dsl/operations/backup.ts';
export {default as command} from './dsl/operations/command.ts';
export {default as cron} from './dsl/operations/cron.ts';
export {default as defaults} from './dsl/operations/defaults.ts';
export {default as fetch} from './dsl/operations/fetch.ts';
export {default as file} from './dsl/operations/file.ts';
export {default as line} from './dsl/operations/line.ts';
export {default as template} from './dsl/operations/template.ts';
export {default as options} from './dsl/options.ts';
export * as resource from './dsl/resource.ts';
export {default as root} from './dsl/root.ts';
export {default as skip} from './dsl/skip.ts';
export {default as task} from './dsl/task.ts';
export {default as variable} from './dsl/variable.ts';
export {default as variables} from './dsl/variables.ts';

//
// Other useful functions for use in aspects.
//

export type {Path} from './path.ts';

export {default as UnsupportedValueError} from './UnsupportedValueError.ts';
export {log} from './console.ts';
export {default as stat} from './fs/stat.ts';
export {default as path} from './path.ts';
export {default as prompt} from './prompt.ts';
export {default as run} from './run.ts';

// Re-export project-local helpers.

export * as helpers from '../helpers.ts';
