import * as path from 'path';

import ErrorWithMetadata from './ErrorWithMetadata.js';
import {root} from './index.js';
import {COLORS, LOG_LEVEL, log, nextLogLevel} from './console.js';
import dedent from './dedent.js';
import escapeRegExpPattern from './escapeRegExpPattern.js';
import {promises as fs} from './fs.js';
import readAspect from './readAspect.js';
import stringify from './stringify.js';
import {assertAspect} from './types/Project.js';

import type {LogLevel} from './console.js';
import type {Aspect} from './types/Project.js';

export type Options = {
  check: boolean;
  focused: Set<Aspect>;
  logLevel: LogLevel;
  parallel: boolean;
  startAt: {
    found: boolean;
    literal: string;
    fuzzy?: RegExp;
  };
  step: boolean;
  testsOnly: boolean;
};

const {bold} = COLORS;

export default async function getOptions(
  args: Array<string>
): Promise<Options> {
  const options: Options = {
    check: false,
    focused: new Set(),
    logLevel: LOG_LEVEL.INFO,
    parallel: false,
    startAt: {
      found: false,
      literal: '',
    },
    step: false,
    testsOnly: false,
  };

  const directory = path.join(root, 'aspects');

  const entries = await fs.readdir(directory, {withFileTypes: true});

  const aspects: Array<[string, string]> = [];

  for (const entry of entries) {
    if (entry.isDirectory()) {
      const name = entry.name;

      const {description} = await readAspect(path.join(directory, name));

      aspects.push([name, description]);
    }
  }

  // Explode "-qt" (etc) to "-q", "-t".
  const explodedArgs = args.flatMap((arg) => {
    if (arg.match(/^-[dhqtv]{2,}$/)) {
      return Array.from(arg.slice(1)).map((letter) => `-${letter}`);
    } else {
      return arg;
    }
  });

  for (const arg of explodedArgs) {
    if (arg === '--check' || arg === '--dry-run') {
      // Support --check for Ansible compatibility and --dry-run because
      // of my Git muscle memory.
      options.check = true;
    } else if (arg === '--debug' || arg === '-d') {
      options.logLevel = LOG_LEVEL.DEBUG;
    } else if (arg === '--quiet' || arg === '-q') {
      options.logLevel = LOG_LEVEL.NOTICE;
    } else if (arg === '--test' || arg === '-t') {
      options.testsOnly = true;
    } else if (arg === '--help' || arg === '-h') {
      await printUsage(aspects);
      throw new ErrorWithMetadata('aborting');
    } else if (arg === '--parallel') {
      options.parallel = true;
    } else if (
      arg.startsWith('--start-at-task=') ||
      arg.startsWith('--start=')
    ) {
      options.startAt.literal = (
        arg.match(/^--start(?:-at-task)?=(.*)/)?.[1] ?? ''
      ).trim();

      options.startAt.fuzzy = new RegExp(
        [
          '',
          ...options.startAt.literal.split(/\s+/).map(escapeRegExpPattern),
          '',
        ].join('.*'),
        'i'
      );
    } else if (arg === '--step') {
      options.step = true;
    } else if (arg === '--verbose' || arg === '-v') {
      options.logLevel = nextLogLevel(options.logLevel);
    } else if (arg.startsWith('-')) {
      throw new ErrorWithMetadata(
        `unrecognized argument ${stringify(
          arg
        )} - pass "--help" to see allowed options`
      );
    } else {
      try {
        assertAspect(arg);
        options.focused.add(arg);
      } catch {
        throw new ErrorWithMetadata(
          `unrecognized aspect ${stringify(
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

        -d/--debug
           --dry-run
        -f/--force    (not yet implemented)
        -h/--help
           --parallel (experimental)
        -q/--quiet
        -t/--test
        -v/--verbose  (repeat up to four times for more verbosity)
           --start-at-task='aspect | task' # TODO: maybe make -s short variant
           --step

      ${bold`Aspects:`}
    `
  );

  for (const [aspect, description] of aspects) {
    log(`  ${aspect}`);
    log(`    ${description}`);
  }

  log();
}
