import {log} from './console';
import test from './test';

// argv[0] = node executable
// argv[1] = JS script
// argv[2] = script arg 0 etc
log(process.argv);

async function main() {
  await test();
}

main().catch(error => {
  log(`Error: ${error}`);

  process.exit(1);
});
