import {
  attributes,
  backup,
  command,
  file,
  path,
  resource,
  skip,
  task,
  variable,
} from 'fig';

task('make directories', async () => {
  // Some overlap with "dotfiles" aspect here.
  await file({path: '~/.backups', state: 'directory'});
  await file({path: '~/.config', state: 'directory'});
});

task('move originals to ~/.backups', async () => {
  const files = variable.paths('files');

  for (const src of files) {
    await backup({src});
  }
});

task('create symlinks', async () => {
  // Some overlap with "dotfiles" aspect here.
  const files = variable.paths('files');

  for (const src of files) {
    await file({
      force: true,
      path: path.home.join(src),
      src: path.aspect.join('files', src),
      state: 'link',
    });
  }
});

task('fetch neovim.git', async () => {
  if (attributes.distribution === 'debian') {
    await command('git', ['clone', 'https://github.com/neovim/neovim.git/'], {
      chdir: 'vendor',
      creates: 'vendor/neovim',
      raw: true,
    });
  } else {
    skip('not on Debian');
  }
});

task('build Neovim', async () => {
  if (attributes.distribution === 'debian') {
    await command('make', [], {
      chdir: 'vendor/neovim',
      creates: 'vendor/neovim/build/bin/nvim',
    });
  } else {
    skip('not on Debian');
  }
});

task('install Neovim', async () => {
  if (attributes.distribution === 'debian') {
    await command('make', ['install'], {
      chdir: 'vendor/neovim',
      creates: '/usr/local/bin/nvim',
    });
  } else {
    skip('not on Debian');
  }
});

const COMMAND_T_BASE =
  'nvim/pack/bundle/opt/command-t/ruby/command-t/ext/command-t';

task('configure Command-T', async () => {
  const base = resource.file('.config').join(COMMAND_T_BASE);

  await command('ruby', ['extconf.rb'], {
    chdir: base,
    creates: base.join('Makefile'),
  });
});

task('compile Command-T', async () => {
  const bundle = attributes.platform === 'darwin' ? 'ext.bundle' : 'ext.so';
  const base = resource.file('.config').join(COMMAND_T_BASE);

  await command('make', [], {
    chdir: base,
    creates: base.join(bundle),
  });
});

// TODO: note that this doesn't work... when i enter vim it is asking me to dl
// something anyway... the ES ones....
// ie. i have
//      en.utf-8.add
//      en.utf-8.add.spl
//  and it dls
//      es.utf-8.spl
//      es.utf-8.sug
// No spell file for "es" in utf-8
// Download it?
// (Y)es, [N]o:
task('create spell file', async () => {
  const spellfile = path.aspect.join('files/.config/nvim/spell/en.utf-8.add');

  await command(
    'nvim',
    ['-u', 'NONE', '-N', '-c', `mkspell! ${spellfile} | quit`],
    {
      creates: `${spellfile}.spl`,
    }
  );
});

task('update bundle', async () => {
  skip('not yet implemented');
  // update-bundle
});

task('update help tags', async () => {
  await command(resource.support('update-help-tags'), []);
});

task('install neovim gem', async () => {
  await command('gem', ['install', 'neovim'], {
    sudo: true,
  });
});

// added in 1a9f9b9fd and probably not used since...
// pip2 install vim-vint

// general python support for neovim
// pip3 install --upgrade pynvim

// legacy way (commented out) was:
// pip2 install neovim
// pip3 install neovim -- not sure if still needed

// For masochist autocompleter
// pip3 install redis
