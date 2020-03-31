import * as os from 'os';
import * as path from 'path';

import ErrorWithMetadata from './ErrorWithMetadata';
import Context from './Fig/Context';
import {root} from './Fig';
import {LOG_LEVEL, log, setLogLevel} from './console';
import merge from './merge';
import readAspect from './readAspect';
import readProject from './readProject';
import regExpFromString from './regExpFromString';
import simplify from './simplify';
import test from './test';


async function main() {
  if (Context.attributes.uid === 0) {
    throw new ErrorWithMetadata('Cannot run as root');
  }

  let testsOnly = false;

  process.argv.forEach(arg => {
    if (arg === '--debug') {
      setLogLevel(LOG_LEVEL.DEBUG);
    } else if (arg === '--quiet' || arg === '-q') {
      setLogLevel(LOG_LEVEL.ERROR);
    } else if (arg === '--test') {
      testsOnly = true;
    } else if (arg === '--help' || arg === '-h') {
      // TODO: print and exit
    } else {
      // TODO: error for bad args
    }
  });

  // argv[0] = node executable
  // argv[1] = JS script
  // argv[2] = script arg 0 etc
  log.debug(JSON.stringify(process.argv, null, 2));

  if (process.cwd() === root) {
    log.info(`Working from root: ${simplify(root)}`);
  } else {
    log.notice(`Changing to root: ${simplify(root)}`);
    process.chdir(root);
  }

  log.info('Running tests');

  await test();

  if (testsOnly) {
    return;
  }

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
      case 'launchd':
        require('../aspects/launchd');
        break;
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

      for (const [callback, name] of Context.tasks.get(aspect)) {
        log.info(`task: ${name}`);

        await Context.withContext({aspect, variables}, async () => {
          await callback();
        });
      }
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

  process.exit(1);
});
