import Context from '../Context.js';

import type {LogLevel} from '../console.js';
import type {Aspect} from '../types/Project.js';

export default {
  get check(): boolean {
    return Context.options.check;
  },

  get focused(): Set<Aspect> {
    return Context.options.focused;
  },

  get logLevel(): LogLevel {
    return Context.options.logLevel;
  },

  get parallel(): boolean {
    return Context.options.parallel;
  },

  get step(): boolean {
    return Context.options.step;
  },

  get testsOnly(): boolean {
    return Context.options.testsOnly;
  },
};
