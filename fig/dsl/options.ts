import Context from '../Context.ts';

import type {LogLevel} from '../console.ts';
import type {Aspect} from '../types/Project.ts';

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
};
