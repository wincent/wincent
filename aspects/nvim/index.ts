import {
  attributes,
  backup,
  command,
  fetch,
  file,
  helpers,
  path,
  resource,
  skip,
  task,
  variable,
} from 'fig';

const {is, when} = helpers;

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

task('make /opt/nvim', when('debian'), async () => {
  await file({path: '/opt', state: 'directory', sudo: true});
  await file({path: '/opt/nvim', state: 'directory', sudo: true});
});

task('download Neovim appimage', when('debian'), async () => {
  await fetch({
    dest: '/opt/nvim/nvim.appimage',
    encoding: null,
    url: 'https://github.com/neovim/neovim/releases/download/v0.7.0/nvim.appimage',
    sudo: true,
  });
});

task('make Neovim appimage executable', when('debian'), async () => {
  await file({
    path: '/opt/nvim/nvim.appimage',
    mode: '0755',
    state: 'file',
    sudo: true,
  });
});

task('extract Neovim appimage files', when('debian'), async () => {
  await command('/opt/nvim/nvim.appimage', ['--appimage-extract'], {
    chdir: '/opt/nvim',
    creates: '/opt/nvim/squashfs-root',
    sudo: true,
  });
});

const COMMAND_T_BASE = 'nvim/pack/bundle/opt/command-t';
const COMMAND_T_LUA = 'lua/wincent/commandt/lib';
const COMMAND_T_RUBY = 'ruby/command-t/ext/command-t';

task('compile Command-T (Lua)', async () => {
  const bundle =
    attributes.platform === 'darwin' ? 'commandt.bundle' : 'commandt.so';
  const base = resource.file('.config').join(COMMAND_T_BASE, COMMAND_T_LUA);

  await command('make', [], {
    chdir: base,
    creates: base.join(bundle),
  });
});

task('configure Command-T (Ruby)', async () => {
  const base = resource.file('.config').join(COMMAND_T_BASE, COMMAND_T_RUBY);

  await command('ruby', ['extconf.rb'], {
    chdir: base,
    creates: base.join('Makefile'),
  });
});

task('compile Command-T (Ruby)', async () => {
  const bundle = attributes.platform === 'darwin' ? 'ext.bundle' : 'ext.so';
  const base = resource.file('.config').join(COMMAND_T_BASE, COMMAND_T_RUBY);

  await command('make', [], {
    chdir: base,
    creates: base.join(bundle),
  });
});

task('download spell files', async () => {
  for (const url of [
    'https://ftp.nluug.nl/pub/vim/runtime/spell/es.utf-8.spl',
    'https://ftp.nluug.nl/pub/vim/runtime/spell/es.utf-8.sug',
  ]) {
    const dest = path('~/.config/nvim/spell').join(path(url).basename);

    await fetch({
      dest,
      encoding: null, // Spellfiles aren't UTF-8; they are arbitrary binary.
      url,
    });
  }
});

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
  await skip('not yet implemented');
  // update-bundle
});

task('update help tags', async () => {
  await command(resource.support('update-help-tags'), []);
});

task('install gems', async () => {
  const gems = ['neovim'];

  // TODO: maybe expose profile more directly in the DSL
  const profile = variable('profile');
  if (profile === 'codespaces' || profile === 'work') {
    gems.push('sorbet', 'solargraph');
  }

  await command('gem', ['install', ...gems], {
    sudo: true,
  });
});

// added in 1a9f9b9fd and probably not used since...
// pip2 install vim-vint

task('install pynvim', async () => {
  if (is('arch')) {
    await command('pip', ['install', '--upgrade', 'pynvim']);
  } else {
    await command('pip3', ['install', '--upgrade', 'pynvim']);
  }
});

// For masochist autocompleter
// pip3 install redis
