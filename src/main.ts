import * as os from 'os';
import * as path from 'path';

import ErrorWithMetadata from './ErrorWithMetadata';
import Context from './Fig/Context';
import {root} from './Fig';
import * as TaskRegistry from './Fig/TaskRegistry';
import {log} from './console';
import merge from './merge';
import readAspect from './readAspect';
import readProject from './readProject';
import regExpFromString from './regExpFromString';
import simplify from './simplify';
import test from './test';

// argv[0] = node executable
// argv[1] = JS script
// argv[2] = script arg 0 etc
log.debug(JSON.stringify(process.argv, null, 2));

async function main() {
  if (process.cwd() === root) {
    log.info(`Working from root: ${simplify(root)}`);
  } else {
    log.notice(`Changing to root: ${simplify(root)}`);
    process.chdir(root);
  }

  log.info('Running tests');

  await test();

  const project = await readProject(path.join(root, 'project.json'));

  const hostname = os.hostname();

  const profiles = project.profiles ?? {};

  const [profile] =
    Object.entries(profiles).find(([, {pattern}]) => {
      if (regExpFromString(pattern).test(hostname)) {
        return true;
      }
    }) || [];

  log.info(`Profile: ${profile || 'n/a'}`);

  const profileVariables: {[key: string]: JSONValue} = profile
    ? profiles[profile]!.variables ?? {}
    : {};

  const platform = Context.attributes.platform;

  log.info(`Platform: ${platform}`);

  const {aspects, variables: platformVariables = {}} = project.platforms[
    platform
  ];

  // Register tasks.
  for (const aspect of aspects) {
    switch (aspect) {
      case 'terminfo':
        require('../aspects/terminfo');
        break;
    }
  }

  const baseVariables = merge(profileVariables, platformVariables);

  // Execute tasks. (Separate step so we can bail on configuration errors before
  // touching filesystem).
  try {
    for (const aspect of aspects) {
      const {description, variables: aspectVariables = {}} = await readAspect(
        path.join(root, 'aspects', aspect, 'aspect.json')
      );
      log.info(`${aspect}: ${description}`);

      const variables = merge(aspectVariables, baseVariables);

      log.debug(`variables:\n\n${JSON.stringify(variables, null, 2)}\n`);

      for (const callback of TaskRegistry.get(aspect)) {
        // TODO: may want to make these async, but will end up polluting
        // everything with `await` keywords... better to use blocking sync
        // everywhere I think
        Context.withContext({aspect, variables}, () => {
          callback();
        });
      }
    }
  } catch (error) {
    if (error instanceof ErrorWithMetadata) {
      if (error.metadata) {
        log.error(
          `${error.message}\n\n${JSON.stringify(error.metadata, null, 2)}\n`
        );
      } else {
        log.error(error.message);
      }
    } else {
      log.error(error.toString());
    }
  } finally {
    const counts = Object.entries(Context.counts)
      .map(([name, count]) => {
        return `${name}=${count}`;
      })
      .join(' ');

    log.info(`Summary: ${counts}`);
  }
}

main().catch((error) => {
  log.error(error);

  process.exit(1);
});
