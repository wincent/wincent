import {attributes, command, line, skip, task, variable} from 'fig';

const homebrewPath = () => {
  if (attributes.arch === 'arm64') {
    return '/opt/homebrew/bin/zsh';
  } else {
    return '/usr/local/bin/zsh';
  }
};

task('add zsh to /etc/shells', async () => {
  if (attributes.platform === 'darwin') {
    await line({
      group: 'wheel',
      line: homebrewPath(),
      owner: 'root',
      path: '/etc/shells',
      sudo: true,
    });
  } else {
    skip('no need to touch /etc/shells unless on Darwin');
  }
});

task('set user shell to zsh', async () => {
  if (variable('identity') === 'wincent') {
    if (attributes.platform === 'darwin') {
      await command('chsh', ['-s', homebrewPath(), attributes.username], {
        sudo: true,
      });
    } else {
      await command('chsh', ['-s', '/bin/zsh', attributes.username], {
        sudo: true,
      });
    }
  } else {
    skip();
  }
});
