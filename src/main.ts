import * as os from 'os';
import * as path from 'path';

import Attributes from './Attributes';
import {root} from './Fig';
import {log} from './console';
import readAspect from './readAspect';
import readProject from './readProject';
import regExpFromString from './regExpFromString';
import test from './test';

// argv[0] = node executable
// argv[1] = JS script
// argv[2] = script arg 0 etc
log.debug(JSON.stringify(process.argv, null, 2));

async function main() {
  log.info('Running tests');
  await test();

  // Determine profile.
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

  const attributes = new Attributes();

  const platform = await attributes.getPlatform();

  log.info(`Platform: ${platform}`);

  const platforms = project.platforms;

  const {aspects} = project.platforms[platform];

  for (const aspect of aspects) {
    const {description, variables} = await readAspect(
      path.join(root, 'aspects', aspect, 'aspect.json')
    );
    log.info(`${aspect}: ${description}`);
    console.log(variables);

    switch (aspect) {
      case 'terminfo':
        require('../aspects/terminfo');
        break;
    }
  }

  // TODO: decide whether to register tasks for deferred running, or run them eagerly
}

main().catch((error) => {
  log.error(error);

  process.exit(1);
});
