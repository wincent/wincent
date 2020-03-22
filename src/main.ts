import * as fs from 'fs';
import * as os from 'os';
import * as path from 'path';
import {promisify} from 'util';

import {root} from './Fig';
import {log} from './console';
import regExpFromString from './regExpFromString';
import test from './test';
import {readProject} from './types/project';

const readFile = promisify(fs.readFile);

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
    Object.entries(profiles).find(([, pattern]) => {
      if (regExpFromString(pattern).test(hostname)) {
        return true;
      }
    }) || [];

  log.info(`Profile: ${profile || 'n/a'}`);

  log.info('Running runbooks');

  // TODO: logic to determine whether to load/run this runbook
  require('../aspects/terminfo');

  // TODO: decide whether to register tasks for deferred running, or run them eagerly
}

main().catch((error) => {
  log.error(error);

  process.exit(1);
});
