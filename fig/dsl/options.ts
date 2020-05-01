import Context from '../Context.js';

import type {LogLevel} from '../console.js';
import type {Aspect} from '../types/Project.js';

export default {
    get check(): boolean {
        return Context.currentOptions.check;
    },

    get focused(): Set<Aspect> {
        return Context.currentOptions.focused;
    },

    get logLevel(): LogLevel {
        return Context.currentOptions.logLevel;
    },

    get step(): boolean {
        return Context.currentOptions.step;
    },

    get testsOnly(): boolean {
        return Context.currentOptions.testsOnly;
    },
};
