// Compile with: `bin/tsgo`
// Run with: `bin/node lib/aspects/homebrew/support/updateBrewfile.mjs`

import {spawn} from 'node:child_process';
import * as fs from 'node:fs/promises';
import {homedir} from 'node:os';
import * as path from 'node:path';

/**
 * Promise class that provides wrapped `resolve` and `reject` callbacks with
 * built-in checks to prevent you from settling twice. Makes it easier to wrap a
 * promise around the multiple callbacks that you can listen to from
 * `child_process.spawn`.
 */
class SimplePromise<T> extends Promise<T> {
  constructor(executor: ConstructorParameters<typeof Promise<T>>[0]) {
    super((resolve, reject) => {
      let settled = false;

      executor(
        (value: Parameters<typeof resolve>[0]): ReturnType<typeof resolve> => {
          if (!settled) {
            settled = true;
            resolve(value);
          }
        },
        (reason?: Parameters<typeof reject>[0]): ReturnType<typeof reject> => {
          if (!settled) {
            settled = true;
            reject(reason);
          }
        },
      );
    });
  }
}

const DUMP_FORMAT = /^(?<kind>\w+)\s+"(?<name>[^"]+)"(\s*,\s*(?<trailer>.+))?$/;

try {
  await main();
} catch (error) {
  console.error(error);
  process.exit(1);
}

async function main(): Promise<void> {
  const taps = [];
  const formulae: {
    [name: string]: {
      name: string;
      dependencies: Array<string>;
      description: string;
      tap: string;
      trailer: string | undefined;
    };
  } = {};
  const casks: {
    [name: string]: {
      name: string;
      description: string;
      tap: string;
      trailer: string | undefined;
    };
  } = {};
  const dump = await brew('bundle', 'dump', '--file=-');

  // Running `brew info` is slow, so we'll do it in parallel, and print
  // status as we go to show progress.
  const awaitables = [];

  for (const line of dump.trim().split(/\n/)) {
    const match = line.match(DUMP_FORMAT);
    if (match?.groups) {
      const {kind, name, trailer} = match.groups;
      const progress = () => console.log(`${kind}: ${name}`);

      if (kind === 'tap') {
        progress();
        taps.push(name);
      } else if (kind === 'brew') {
        awaitables.push(async () => {
          progress();
          const info = await brew('info', '--json', name);
          const parsedInfo = JSON.parse(info);
          if (parsedInfo.length === 1) {
            const {dependencies, desc: description, tap} = parsedInfo[0];
            validate(dependencies, 'Array<string>');
            validate(description, 'string');
            validate(tap, 'string');
            formulae[name] = {
              name,
              dependencies,
              description,
              tap,
              trailer,
            };
          } else {
            throw new Error(
              `Expected a single formula but got ${parsedInfo.length} for formula ${name}`,
            );
          }
        });
      } else if (kind === 'cask') {
        awaitables.push(async () => {
          progress();

          // Use `--json=v2` because otherwise casks blow up.
          //
          // - `brew info blurred` works; and:
          // - `brew info --cask blurred` works; and:
          // - `brew info --json=v2 blurred` works; but:
          // - `brew info --json blurred` blows up with:
          //    No available formula with the name "blurred".
          //
          // We also pass `--cask` because otherwise:
          //
          // - `brew info --json=v2 docker` complains:
          //    Warning: Treating docker as a formula. For the cask, use
          //    homebrew/cask/docker or specify the `--cask` flag.
          //    To silence this message, use the `--formula` flag.
          //
          const info = await brew('info', '--cask', '--json=v2', name);
          const {casks: parsedCasks} = JSON.parse(info);
          if (parsedCasks.length === 1) {
            const {desc: description, tap} = parsedCasks[0];
            validate(description, 'string');
            validate(tap, 'string');
            casks[name] = {
              name,
              description,
              tap,
              trailer,
            };
          } else {
            throw new Error(
              `Expected a single cask but got ${casks.length} for cask ${name}`,
            );
          }
        });
      }
    }
  }

  await parallel(awaitables);

  // console.log(taps);
  // console.log(formulae);
  // console.log(casks);

  // Compare against installed Brewfile to avoid false negatives and positives
  // based on running against template with both personal and work sections.
  const brewfile = path.join(homedir(), 'Library', 'Preferences', 'Brewfile');
  const contents = await fs.readFile(brewfile, 'utf8');
  console.log(contents);

  const usedTaps = new Set(
    [...Object.values(formulae), ...Object.values(casks)].map(
      (item) => item.tap,
    ),
  );
  const dumpedTaps = new Set(taps);

  // TODO: us "esnext" target in tsconfig.json for `Set.difference` (not in ES2024 target).
  // @ts-expect-error
  const tapsDifference = dumpedTaps.difference(usedTaps);

  if (tapsDifference.size) {
    console.log('Dumped taps:', Array.from(dumpedTaps).sort());
    console.log('Used taps:', Array.from(usedTaps).sort());
    console.log('Difference:', Array.from(tapsDifference).sort());
    // NOTE: this isn't the real comparison we care about... we care about what
    // is in the brewfile but not used, or what is not in the brewfile but
    // should be.
    // Declared taps: [
    //   'homebrew/bundle',
    //   'homebrew/services',
    //   'oven-sh/bun',
    //   'tavianator/tap',
    //   'withgraphite/tap'
    // ]
    // Used taps: [
    //   'homebrew/cask',
    //   'homebrew/core',
    //   'oven-sh/bun',
    //   'tavianator/tap',
    //   'withgraphite/tap'
    // ]
    // Difference: [ 'homebrew/bundle', 'homebrew/services' ]
  }

  // TODO:
  // update descriptions
  // list items that _should _be added
  // and items that _could_ be removed
  // something about dependencies too (list things that aren't depended on by
  // anything else?); we can do that but given the work/personal split, it is
  // going to produce both false positives and false negatives, I think?
}

async function brew(
  subcommand: string,
  ...args: Array<string>
): Promise<string> {
  return run('brew', [subcommand, ...args]);
}

/**
 * Run `awaitables` with the specified `concurrency`.
 */
async function parallel<T>(
  awaitables: Array<() => Promise<T>>,
  concurrency: number = 10,
): Promise<Array<T>> {
  const results: Array<T> = [];
  const running = new Map<number, Promise<number>>();

  for (let i = 0; i < awaitables.length; i++) {
    const awaitable = awaitables[i];
    const promise = awaitable().then((result) => {
      results[i] = result;
      return i;
    });
    running.set(i, promise);

    if (running.size >= concurrency) {
      await Promise.race(running.values()).then((settled) => {
        running.delete(settled);
      });
    }
  }

  await Promise.all(running.values());

  return results;
}

function run(command: string, args: Array<string> = []): Promise<string> {
  return new SimplePromise((resolve, reject) => {
    const description = `${command} ${args.join(' ')}`;
    const child = spawn(command, args);
    let stdout = '';

    child.stderr.pipe(process.stderr);

    child.stdout.on('data', (data) => {
      stdout += data.toString();
    });

    child.on('close', (code) => {
      if (code === 0) {
        resolve(stdout);
      }
    });

    child.on('error', (error) => {
      reject(
        new Error(`${description} failed`, {
          cause: error,
        }),
      );
    });

    child.on('exit', (status, signal) => {
      if (signal) {
        reject(new Error(`${description} exited due to signal ${signal}`));
      } else if (status !== 0) {
        reject(new Error(`${description} exited with status ${status}`));
      }
    });
  });
}

function validate(
  value: unknown,
  kind: 'Array<string>',
): asserts value is Array<string>;
function validate(value: unknown, kind: 'string'): asserts value is string;
function validate(value: unknown, kind: 'Array<string>' | 'string'): void {
  if (kind === 'Array<string>') {
    if (!Array.isArray(value)) {
      throw new Error(`Expected value ${JSON.stringify(value)} to be an array`);
    }
    for (const item of value) {
      if (typeof item !== 'string') {
        throw new Error(
          `Expected array item ${
            JSON.stringify(
              item,
            )
          } to be string but it was ${typeof item}`,
        );
      }
    }
  } else if (kind === 'string') {
    if (typeof value !== 'string') {
      throw new Error(
        `Expected value ${
          JSON.stringify(
            value,
          )
        } to be string but it was ${typeof value}`,
      );
    }
  }
}
