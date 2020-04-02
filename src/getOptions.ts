import {promises as fs} from 'fs';
import * as path from 'path';

import {root} from './Fig';
import {COLORS, LOG_LEVEL, log, setLogLevel} from './console';
import dedent from './dedent';
import ErrorWithMetadata from './ErrorWithMetadata';
import escapeRegExpPattern from './escapeRegExpPattern';
import readAspect from './readAspect';
import {assertAspect} from './types/Project';

import type {LogLevel} from './console';
import type {Aspect} from './types/Project';

type Options = {
  focused: Set<Aspect>;
  logLevel: LogLevel;
  startAt: {
    found: boolean;
    literal: string;
    fuzzy?: RegExp;
  };
  testsOnly: boolean;
};

const {bold} = COLORS;

export default async function getOptions(
  args: Array<string>
): Promise<Options> {
  const options: Options = {
    focused: new Set(),
    logLevel: LOG_LEVEL.INFO,
    startAt: {
      found: false,
      literal: '',
    },
    testsOnly: false,
  };

  const directory = path.join(root, 'aspects');

  const entries = await fs.readdir(directory, {withFileTypes: true});

  const aspects: Array<[string, string]> = [];

  for (const entry of entries) {
    if (entry.isDirectory()) {
      const name = entry.name;

      const {description} = await readAspect(
        path.join(directory, name, 'aspect.json')
      );

      aspects.push([name, description]);
    }
  }

  for (const arg of args) {
    if (arg === '--debug' || arg === '-d') {
      options.logLevel = LOG_LEVEL.DEBUG;
    } else if (arg === '--quiet' || arg === '-q') {
      options.logLevel = LOG_LEVEL.NOTICE;
    } else if (arg === '--test' || arg === '-t') {
      options.testsOnly = true;
    } else if (arg === '--help' || arg === '-h') {
      await printUsage(aspects);
      throw new ErrorWithMetadata('aborting');
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
    } else if (arg.startsWith('-')) {
      throw new ErrorWithMetadata(
        `unrecognized argument ${JSON.stringify(
          arg
        )} - pass "--help" to see allowed options`
      );
    } else {
      try {
        assertAspect(arg);
        options.focused.add(arg);
      } catch {
        throw new ErrorWithMetadata(
          `unrecognized aspect ${JSON.stringify(
            arg
          )} - pass "--help" to see full list`
        );
      }
    }
  }

  return options;
}

async function printUsage(aspects: Array<[string, string]>) {
  // TODO: actually implement all the switches mentioned here
  log(
    dedent`

      ./install [options] [aspects...]

      ${bold`Options:`}

        -c/--check # not yet implemented
        -d/--debug
        -f/--force # not yet implemented
        -h/--help
        -q/--quiet
        -t/--test
        -v/--verbose (repeat up to four times for more verbosity) # not yet implemented
        --start-at-task='aspect | task' # TODO: maybe make -s short variant
        --step # not yet implemented

      ${bold`Aspects:`}
    `
  );

  for (const [aspect, description] of aspects) {
    log(`  ${aspect}`);
    log(`    ${description}`);
  }

  log();
}
