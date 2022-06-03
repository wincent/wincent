import {attributes, command, helpers, line, task} from 'fig';

const {is, when} = helpers;

const homebrewPath = () => {
  if (is('arm64')) {
    return '/opt/homebrew/bin/zsh';
  } else {
    return '/usr/local/bin/zsh';
  }
};

task('add zsh to /etc/shells', when('darwin'), async () => {
  await line({
    group: 'wheel',
    line: homebrewPath(),
    owner: 'root',
    path: '/etc/shells',
    sudo: true,
  });
});

task('set user shell to zsh', when('wincent'), async () => {
  if (is('darwin')) {
    await command('chsh', ['-s', homebrewPath(), attributes.username], {
      sudo: true,
    });
  } else {
    await command('chsh', ['-s', '/bin/zsh', attributes.username], {
      sudo: true,
    });
  }
});
