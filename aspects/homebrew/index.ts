import {existsSync} from 'node:fs';
import {dirname, join} from 'node:path';
import {fileURLToPath, pathToFileURL} from 'node:url';

import {command, fail, fetch, helpers, log, prompt, task} from 'fig';

const {when} = helpers;

// `work.ts` contains potentially sensitive corp details (tap URLs, internal
// formula/cask names) so it is encrypted; only imported when its plaintext is
// available on disk.
const workPath = join(dirname(fileURLToPath(import.meta.url)), 'work.ts');
const workDecrypted = existsSync(workPath);

//
// Tasks are executed in registration order, so the bootstrap tasks below must
// be registered _before_ we import the per-profile modules (each of which
// registers one `task()` per item to install).
//

task('download installation script', async () => {
  await fetch({
    dest: 'vendor/homebrew/install.sh',
    mode: '0755',
    url: 'https://raw.githubusercontent.com/Homebrew/install/master/install.sh',
  });
});

task('install Homebrew', async () => {
  log.notice(
    'Homebrew requires manual installation.\n' +
      '\n' +
      'Specifically, it uses an interactive sudo prompt part way through,\n' +
      'and some parts of the script must run without privileges and others\n' +
      'with privileges. As such, we can\'t just run it in "non-interactive"\n' +
      'mode as root.\n' +
      '\n' +
      'Please run:\n' +
      '\n' +
      '    vendor/homebrew/install.sh\n' +
      '\n',
  );
  const answer = await prompt.confirm('Confirm that Homebrew is installed');

  if (!answer) {
    fail('User aborted');
  }

  // Hopefully, will be able to go back to doing this in the future:
  //
  //    await command('vendor/homebrew/install.sh', [], {
  //      creates: '/usr/local/bin/brew',
  //    });
  //
  // or on Apple Silicon:
  //
  //    await command('vendor/homebrew/install.sh', [], {
  //      creates: '/opt/homebrew/bin/brew',
  //    });
});

task('update Homebrew', async () => {
  await command('brew', ['update']);
});

task('warn if work tasks are encrypted', when('work'), async () => {
  if (!workDecrypted) {
    await log.warn(
      `"${workPath}" does not exist; run "bin/decrypt" to populate`,
    );
  }
});

//
// Per-profile package installation tasks.
//

await import('./common.ts');
await import('./personal.ts');

if (workDecrypted) {
  // Import by computed URL so TypeScript doesn't attempt to resolve the
  // specifier at compile time (the file may not exist on fresh checkouts).
  await import(pathToFileURL(workPath).href);
}

//
// Cleanup runs after everything has been installed.
//

task('clean up old versions', async () => {
  await command('brew', ['cleanup']);
});
