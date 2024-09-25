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

const {when} = helpers;

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


const COMMAND_T_BASE = 'nvim/pack/bundle/opt/command-t';
const COMMAND_T_LUA = 'lua/wincent/commandt/lib';
const COMMAND_T_RUBY = 'ruby/command-t/ext/command-t';

task('compile Command-T (Lua)', async () => {
  const bundle = attributes.platform === 'darwin'
    ? 'commandt.bundle'
    : 'commandt.so';
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

task('build shellbot', async () => {
  const base = resource.file('.config').join(
    'nvim/pack/bundle/opt/shellbot/lua',
  );

  await command('cargo', ['build', '--release'], {
    chdir: base,
    creates: base.join('target/release/shellbot'),
  });
});

task('download spell files', async () => {
  for (
    const url of [
      'https://ftp.nluug.nl/pub/vim/runtime/spell/es.utf-8.spl',
      'https://ftp.nluug.nl/pub/vim/runtime/spell/es.utf-8.sug',
    ]
  ) {
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
    },
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

  await command('gem', ['install', ...gems], {
    sudo: true,
  });
});

// On my work machine, I divide my Corpus notes into two folders: one is
// work-specific, synced via Google Drive, and the other has personal notes
// in it and is not synced. Because Google Drive isn't good at handling Git
// directories, I store that elsewhere, and it doesn't get synced.
task('create Corpus directories', when('wincent', 'work'), async () => {
  // Corporate Corpus files go here.
  await file({path: '~/Documents/Corporate', state: 'directory'});
  await file({path: '~/Documents/Corporate/Corpus', state: 'directory'});

  // Git directory goes under `~/Library/Application Support/Corpus`, with
  // subdirectories of the form "$HOME-relative path to Corpus files" and a
  // `.git` extension.
  await file({
    path: '~/Library/Application Support/Corpus',
    state: 'directory',
  });
  await file({
    path: '~/Library/Application Support/Corpus/Documents',
    state: 'directory',
  });
  await file({
    path: '~/Library/Application Support/Corpus/Documents/Corporate',
    state: 'directory',
  });
  await file({
    path: '~/Library/Application Support/Corpus/Documents/Corporate/Corpus.git',
    state: 'directory',
  });

  await command('git', [
    'init',
    `--separate-git-dir=${
      path.home.join(
        'Library/Application Support/Corpus/Documents/Corporate/Corpus.git',
      )
    }`,
  ], {
    chdir: '~/Documents/Corporate/Corpus',
    creates: '~/Documents/Corporate/Corpus/.git',
  });

  await file({path: '~/Documents/Personal', state: 'directory'});
  await file({path: '~/Documents/Personal/Corpus', state: 'directory'});

  await command('git', ['init'], {
    chdir: '~/Documents/Personal/Corpus',
    creates: '~/Documents/Personal/Corpus/.git',
  });
});

// added in 1a9f9b9fd and probably not used since...
// pip2 install vim-vint

// For masochist autocompleter
// pip3 install redis
