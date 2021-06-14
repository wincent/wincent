import {attributes, command, line, skip, task, variable} from 'fig';

const homebrewPath = () => {
  if (attributes.arch === 'arm64') {
    return '/opt/homebrew/bin/zsh';
  } else {
    return '/usr/local/bin/zsh';
  }
};

task('add zsh to /etc/shells', async () => {
  if (attributes.distribution === 'arch') {
    skip('no need to touch /etc/shells on Arch');
  } else if (attributes.distribution === 'debian') {
    skip('no need to touch /etc/shells on Debian');
  } else {
    await line({
      group: 'wheel',
      line: homebrewPath(),
      owner: 'root',
      path: '/etc/shells',
      sudo: true,
    });
  }
});

task('set user shell to zsh', async () => {
  if (variable('identity') === 'wincent') {
    if (attributes.distribution === 'arch') {
      await command('chsh', ['-s', '/bin/zsh', attributes.username], {
        sudo: true,
      });
    } else if (attributes.distribution === 'debian') {
      await command('chsh', ['-s', '/bin/zsh', attributes.username]);
    } else {
      await command('chsh', ['-s', homebrewPath(), attributes.username], {
        sudo: true,
      });
    }
  } else {
    skip();
  }
});
