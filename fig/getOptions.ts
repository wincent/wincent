import * as assert from 'node:assert';
import * as path from 'node:path';

import ErrorWithMetadata from './ErrorWithMetadata.ts';
import {COLORS, LOG_LEVEL, log, nextLogLevel} from './console.ts';
import dedent from './dedent.ts';
import root from './dsl/root.ts';
import escapeRegExpPattern from './escapeRegExpPattern.ts';
import {promises as fs} from './fs.ts';
import readAspect from './readAspect.ts';
import stringify from './stringify.ts';
import {assertAspect} from './types/Project.ts';

import type {LogLevel} from './console.ts';
import type {Aspect} from './types/Project.ts';

export type Options = {
  check: boolean;
  excluded: Set<Aspect>;
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
  args: Array<string>,
): Promise<Options> {
  const options: Options = {
    check: false,
    excluded: new Set(),
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
    if (arg.match(/^-[dhqstv]{2,}$/)) {
      return Array.from(arg.slice(1)).map((letter) => `-${letter}`);
    } else {
      return arg;
    }
  });

  while (explodedArgs.length) {
    const arg = explodedArgs.shift();
    assert.ok(arg);

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
    } else if (arg === '-s' || arg === '--start' || arg === '--start-at-task') {
      const task = explodedArgs.shift()?.trim();
      if (task === undefined) {
        throw new ErrorWithMetadata(
          `missing <aspect-or-task> pattern for ${arg} switch`,
        );
      } else if (task.startsWith('-')) {
        throw new ErrorWithMetadata(
          `invalid <aspect-or-task> pattern ${
            stringify(
              task,
            )
          } for ${arg} switch`,
        );
      }
      options.startAt.literal = task;
      options.startAt.fuzzy = fuzz(task);
    } else if (
      arg.startsWith('--start-at-task=') ||
      arg.startsWith('--start=')
    ) {
      const task = (
        arg.match(/^--start(?:-at-task)?=(['"])(.*)(\1)$/)?.[2] ??
          arg.match(/^--start(?:-at-task)?=(.*)/)?.[1] ??
          ''
      ).trim();
      options.startAt.literal = task;
      options.startAt.fuzzy = fuzz(task);
    } else if (arg === '--step') {
      options.step = true;
    } else if (arg === '--verbose' || arg === '-v') {
      options.logLevel = nextLogLevel(options.logLevel);
    } else if (arg.startsWith('-')) {
      throw new ErrorWithMetadata(
        `unrecognized argument ${
          stringify(
            arg,
          )
        } - pass "--help" to see allowed options`,
      );
    } else if (arg.startsWith('^') || arg.startsWith('!')) {
      const sliced = arg.slice(1);
      try {
        assertAspect(sliced);
        options.excluded.add(sliced);
      } catch {
        throw new ErrorWithMetadata(
          `unrecognized aspect ${
            stringify(
              sliced,
            )
          } - pass "--help" to see full list`,
        );
      }
    } else {
      try {
        assertAspect(arg);
        options.focused.add(arg);
      } catch {
        throw new ErrorWithMetadata(
          `unrecognized aspect ${
            stringify(
              arg,
            )
          } - pass "--help" to see full list`,
        );
      }
    }
  }

  return options;
}

/**
 * Turn `value` into a fuzzy RegExp.
 *
 * eg. "foo bar baz" → /foo.*bar.*baz/
 */
function fuzz(value: string) {
  return new RegExp(
    ['', ...value.split(/\s+/).map(escapeRegExpPattern), ''].join('.*'),
    'i',
  );
}

async function printUsage(aspects: Array<[string, string]>) {
  // TODO: actually implement all the switches mentioned here
  await log(
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
        -s/--start-at-task <aspect-or-task>
           --step

      ${bold`Aspects:`}
    `,
  );

  for (const [aspect, description] of aspects) {
    await log(`  ${aspect}`);
    await log(`    ${description}`);
  }

  await log();
}
