import {join} from 'node:path';
import * as process from 'node:process';

import variables from '../variables.ts';
import Context from './Context.ts';
import ErrorWithMetadata from './ErrorWithMetadata.ts';
import {debug, log, setLogLevel} from './console.ts';
import dedent from './dedent.ts';
import getOptions from './getOptions.ts';
import {root} from './index.ts';
import merge from './merge.ts';
import path from './path.ts';
import prompt from './prompt.ts';
import readAspect from './readAspect.ts';
import readConfig from './readConfig.ts';
import regExpFromString from './regExpFromString.ts';
import stringify from './stringify.ts';
import test from './test.ts';

import type {Aspect} from './types/Project.ts';

class AbortError extends Error {}

async function main() {
  const start = Date.now();

  if (Context.attributes.uid === 0) {
    if (!process.env.YOLO) {
      throw new ErrorWithMetadata('Refusing to run as root unless YOLO is set');
    }
  }

  // Skip first two args (node executable and main.ts script).
  const options = await getOptions(process.argv.slice(2));
  Context.options = options;

  setLogLevel(options.logLevel);

  await debug(async () => {
    await log.debug('process.argv:\n\n' + stringify(process.argv) + '\n');
    await log.debug('getOptions():\n\n' + stringify(options) + '\n');
  });

  if (process.cwd() === root) {
    await log.info(`Working from root: ${path(root).simplify}`);
  } else {
    await log.notice(`Changing to root: ${path(root).simplify}`);
    process.chdir(root);
  }

  await log.info('Running tests');

  await test();

  if (options.testsOnly) {
    return;
  }

  const project = await readConfig(root);

  const hostname = Context.attributes.hostname;

  const profiles = project.profiles ?? {};

  const [profile] =
    Object.entries(profiles).find(([, {pattern}]) =>
      regExpFromString(pattern).test(hostname)
    ) || [];

  await log.info(`Profile: ${profile || 'n/a'}`);

  await log.debug(`Profiles:\n\n${stringify(profiles)}\n`);

  const profileVariables: {[key: string]: JSONValue} = profile
    ? profiles[profile]!.variables ?? {}
    : {};

  const {distribution, platform} = Context.attributes;

  await log.info(`Platform: ${platform}`);

  const platformVariant:
    | `${typeof platform}.${Exclude<typeof distribution, ''>}`
    | typeof platform = distribution ? `${platform}.${distribution}` : platform;

  const {aspects, variables: platformVariables = {}} = project.platforms[
    platformVariant
  ] ||
    project.platforms[platform] || {aspects: []};

  // Register tasks.
  const candidateTasks = [];

  for (const aspect of aspects.flat()) {
    await loadAspect(aspect);

    if (
      (options.focused.size && !options.focused.has(aspect)) ||
      (options.excluded.size && options.excluded.has(aspect))
    ) {
      continue;
    }

    // Check for an exact match of the starting task if `--start-at-task=` was
    // supplied.
    for (const [, name] of Context.tasks.get(aspect)) {
      if (name === options.startAt.literal) {
        options.startAt.found = true;
      } else if (
        !options.startAt.found &&
        options.startAt.fuzzy?.test(name)
      ) {
        candidateTasks.push(name);
      }
    }
  }

  if (!options.startAt.found && candidateTasks.length === 1) {
    await log.notice(`Matching task found: ${candidateTasks[0]}`);

    await log();

    if (await prompt.confirm('Start running at this task')) {
      options.startAt.found = true;
      options.startAt.literal = candidateTasks[0];
    } else {
      throw new ErrorWithMetadata('User aborted');
    }
  } else if (!options.startAt.found && candidateTasks.length > 1) {
    await log.notice(`${candidateTasks.length} tasks found:\n`);

    const width = candidateTasks.length.toString().length;

    while (!options.startAt.found) {
      let i = 0;
      for (const name of candidateTasks) {
        await log(`${(i + 1).toString().padStart(width)}: ${name}`);
        i++;
      }

      await log();

      const reply = await prompt('Start at task number: ');

      const choice = parseInt(reply.trim(), 10);

      if (
        Number.isNaN(choice) ||
        choice < 1 ||
        choice > candidateTasks.length
      ) {
        await log.warn(
          `Invalid choice ${
            stringify(
              reply,
            )
          }; try again or press CTRL-C to abort.`,
        );

        await log();
      } else {
        options.startAt.found = true;
        options.startAt.literal = candidateTasks[choice - 1];
      }
    }
  } else if (!options.startAt.found && options.startAt.literal) {
    throw new ErrorWithMetadata(
      `Failed to find task matching ${stringify(options.startAt.literal)}`,
    );
  }

  const attributeVariables = {
    home: Context.attributes.home,
    hostname: Context.attributes.hostname,
    platform: Context.attributes.platform,
    username: Context.attributes.username,
  };

  const defaultVariables = project.variables ?? {};

  const baseVariables = merge(
    {profile: profile || null},
    attributeVariables,
    defaultVariables,
    profileVariables,
    platformVariables,
    variables,
  );

  // TODO: maybe this should be called registerBaseVariables
  Context.variables.registerGlobalVariables(baseVariables);

  // Execute tasks.
  try {
    let stepping = options.step;

    // Execute within each batch in parallel, unless stepping.
    const batches = aspects.flatMap((groupOrAspect) => {
      if (Array.isArray(groupOrAspect)) {
        if (stepping || !options.parallel) {
          return groupOrAspect.map((aspect) => [aspect]);
        } else {
          return [groupOrAspect];
        }
      } else {
        return [[groupOrAspect]];
      }
    });

    for (const batch of batches) {
      const promises = batch.map(async (aspect) => {
        const {variables: aspectVariables = {}} = await readAspect(
          join(root, 'aspects', aspect),
        );

        if (
          (options.focused.size && !options.focused.has(aspect)) ||
          (options.excluded.size && options.excluded.has(aspect))
        ) {
          await log.info(`Skipping aspect: ${aspect}`);
          return;
        }

        const mergedVariables = merge(baseVariables, aspectVariables);

        const variables = merge(
          mergedVariables,
          Context.variables.getVariablesCallback(aspect)(mergedVariables),
        );

        await log.debug(`Variables:\n\n${stringify(variables)}\n`);

        for (const [callback, name] of Context.tasks.get(aspect)) {
          if (!options.startAt.found || name === options.startAt.literal) {
            options.startAt.found = false;
            await log.notice(`Task: ${name}`);

            if (stepping) {
              for (;;) {
                const reply = (
                  await prompt(
                    `Run task ${name}? [y]es/[n]o/[q]uit]/[c]ontinue/[h]elp: `,
                  )
                )
                  .toLowerCase()
                  .trim();

                if ('yes'.startsWith(reply)) {
                  await Context.execute(
                    {
                      aspect,
                      task: name,
                      variables,
                    },
                    callback,
                  );
                  break;
                } else if ('no'.startsWith(reply)) {
                  await Context.informSkipped(`task ${name}`);
                  break;
                } else if ('quit'.startsWith(reply)) {
                  throw new AbortError();
                } else if ('continue'.startsWith(reply)) {
                  stepping = false;
                  await Context.execute(
                    {
                      aspect,
                      task: name,
                      variables,
                    },
                    callback,
                  );
                  break;
                } else if ('help'.startsWith(reply)) {
                  await log(
                    dedent`
                      [y]es:      run the task
                      [n]o:       skip the task
                      [q]uit:     stop running
                      [c]ontinue: run all remaining tasks
                    `,
                  );
                } else {
                  await log.warn('Invalid choice; try again.');
                }
              }
            } else {
              await Context.execute({aspect, task: name, variables}, callback);
            }
          }
        }

        if (!options.startAt.found) {
          const {callbacks, notifications} = Context.handlers.get(aspect);

          for (const name of notifications) {
            await log.notice(`Handler: ${name}`);

            const callback = callbacks.get(name);

            if (!callback) {
              throw new ErrorWithMetadata(
                `Failed to find handler with named ${stringify(name)}`,
              );
            }

            if (stepping) {
              // TODO: DRY up -- almost same as task handling
              // above
              for (;;) {
                const reply = (
                  await prompt(
                    `Run handler ${name}? [y]es/[n]o/[q]uit]/[c]ontinue/[h]elp: `,
                  )
                )
                  .toLowerCase()
                  .trim();

                if ('yes'.startsWith(reply)) {
                  await Context.execute(
                    {
                      aspect,
                      task: name,
                      variables,
                    },
                    callback,
                  );
                  break;
                } else if ('no'.startsWith(reply)) {
                  await Context.informSkipped(`handler ${name}`);
                  break;
                } else if ('quit'.startsWith(reply)) {
                  throw new AbortError();
                } else if ('continue'.startsWith(reply)) {
                  stepping = false;
                  await Context.execute(
                    {
                      aspect,
                      task: name,
                      variables,
                    },
                    callback,
                  );
                  break;
                } else if ('help'.startsWith(reply)) {
                  await log(
                    dedent`
                      [y]es:      run the handler
                      [n]o:       skip the handler
                      [q]uit:     stop running
                      [c]ontinue: run all remaining handlers and tasks
                    `,
                  );
                } else {
                  await log.warn('Invalid choice; try again.');
                }
              }
            } else {
              await Context.execute({aspect, task: name, variables}, callback);
            }
          }

          for (const name of callbacks.keys()) {
            if (!notifications.has(name)) {
              await log.notice(`Handler: ${name}`);
              await Context.informSkipped(`handler ${name}`);
            }
          }
        }
      });

      await Promise.all(promises);
    }
  } catch (error) {
    if (!(error instanceof AbortError)) {
      throw error;
    }
  } finally {
    const counts = Object.entries(Context.counts)
      .map(([name, count]) => {
        return `${name}=${count}`;
      })
      .join(' ');
    const elapsed = msToHumanReadable(Date.now() - start);

    await log.notice(`Summary: ${counts} elapsed=${elapsed}`);
  }
}

/**
 * Turns `ms` into a human readble string like "1m2s" or "33.2s".
 *
 * Doesn't deal with timescales beyond "minutes" because we don't expect to see
 * those. If we did, it would just return (something like) "125m20s".
 */
function msToHumanReadable(ms: number): string {
  let seconds = ms / 1000;
  const minutes = Math.floor(seconds / 60);
  if (minutes) {
    seconds = Math.floor(seconds - minutes * 60);
  }

  let result = minutes ? `${minutes}m` : '';
  result += seconds
    ? seconds.toFixed(2).toString().replace(/0+$/, '').replace(/\.$/, '') + 's'
    : '';

  return result;
}

async function loadAspect(aspect: Aspect): Promise<void> {
  await import(`../aspects/${aspect}/index.ts`);
}

try {
  await main();
} catch (error) {
  if (error instanceof ErrorWithMetadata) {
    if (error.metadata) {
      await log.error(`${error.message}\n\n${stringify(error.metadata)}\n`);
    } else {
      await log.error(error.message);
    }
  } else {
    await log.error(stringify(error));
  }

  if (error instanceof Error) {
    await log.debug(String(error.stack));
  }

  process.exit(1);
}
