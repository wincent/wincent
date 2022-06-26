import {
  command,
  fail,
  fetch,
  log,
  prompt,
  resource,
  skip,
  task,
  template,
} from 'fig';

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
      '\n'
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

task('prepare Brewfile', async () => {
  await template({
    path: '~/Library/Preferences/Brewfile',
    src: resource.template('Brewfile.erb'),
  });
});

task('run "brew bundle"', async () => {
  await command('brew', ['bundle'], {
    chdir: '~/Library/Preferences',
  });
});

task('clean up old versions', async () => {
  await command('brew', ['cleanup']);
});
