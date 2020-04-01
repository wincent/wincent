import {LOG_LEVEL, log, setLogLevel} from './console';
import escapeRegExpPattern from './escapeRegExpPattern';

import type {LogLevel} from './console';

type Options = {
  logLevel: LogLevel;
  startAt: {
    found: boolean;
    literal: string;
    fuzzy?: RegExp;
  };
  testsOnly: boolean;
};

export default function getOptions(args: Array<string>): Options {
  const options: Options = {
    logLevel: LOG_LEVEL.INFO,
    startAt: {
      found: false,
      literal: '',
    },
    testsOnly: false,
  };

  args.forEach((arg) => {
    if (arg === '--debug') {
      options.logLevel = LOG_LEVEL.DEBUG;
    } else if (arg === '--quiet' || arg === '-q') {
      options.logLevel = LOG_LEVEL.NOTICE;
    } else if (arg === '--test') {
      options.testsOnly = true;
    } else if (arg === '--help' || arg === '-h') {
      // TODO: print and exit
    } else if (arg.startsWith('--start-at-task=')) {
      options.startAt.literal = (
        arg.match(/^--start-at-task=(.*)/)?.[1] ?? ''
      ).trim();
      options.startAt.fuzzy = new RegExp(
        [
          '',
          ...options.startAt.literal.split(/\s+/).map(escapeRegExpPattern),
          '',
        ].join('.*'),
        'i'
      );
    } else {
      // TODO: error for bad args
    }
  });

  return options;
}
