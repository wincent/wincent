import {
  command,
  fail,
  fetch,
  helpers,
  log,
  prompt,
  resource,
  skip,
  task,
} from 'fig';

const {isDecrypted, when} = helpers;

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

task('tap "homebrew/bundle"', async () => {
  const result = await command('brew', ['tap']);

  if (/^homebrew\/bundle$/m.test(result!.stdout)) {
    return await skip('already tapped');
  }

  await command('brew', ['tap', 'homebrew/bundle']);
});

task('run `brew bundle` with common Brewfile', async () => {
  await command('brew', ['bundle', `--file=${resource.file('Brewfile')}`]);
});

task('run `brew bundle` with personal Brewfile', when('personal'), async () => {
  await command('brew', [
    'bundle',
    `--file=${resource.file('Brewfile.personal')}`,
  ]);
});

task('run `brew bundle` with work Brewfile', when('work'), async () => {
  const src = resource.file('Brewfile.work');
  const decrypted = await isDecrypted(src);

  if (!decrypted) {
    await log.warn(`"${src}" does not exist; run "bin/decrypt"`);
    return;
  }

  await command('brew', ['bundle', `--file=${src}`]);
});

task('clean up old versions', async () => {
  await command('brew', ['cleanup']);
});
