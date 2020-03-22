import './Fig';

import {log} from './console';
import test from './test';

// argv[0] = node executable
// argv[1] = JS script
// argv[2] = script arg 0 etc
log.debug(JSON.stringify(process.argv, null, 2));

async function main() {
  log.info('Running tests');
  await test();

  log.info('Running runbooks');

  // TODO: logic to determine whether to load/run this runbook
  require('../aspects/terminfo');

  // TODO: decide whether to register tasks for deferred running, or run them eagerly
}

main().catch((error) => {
  log.error(error);

  process.exit(1);
});
