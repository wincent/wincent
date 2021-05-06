import {attributes, command, line, skip, task, variable} from 'fig';

task('add /usr/local/bin/zsh to /etc/shells', async () => {
  if (attributes.distribution === 'arch') {
    skip('no need to touch /etc/shells on Arch');
  } else {
    await line({
      group: 'wheel',
      line: '/usr/local/bin/zsh',
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
    } else {
      await command('chsh', ['-s', '/usr/local/bin/zsh', attributes.username], {
        sudo: true,
      });
    }
  } else {
    skip();
  }
});
