import {
  backup,
  command,
  fetch,
  file,
  helpers,
  path,
  resource,
  task,
  variable,
} from 'fig';

const {is, when} = helpers;

const NEOVIM_VERSION = '0.12.1';
const TREE_SITTER_VERSION = '0.26.8';

task('make directories', async () => {
  // Some overlap with "dotfiles" aspect here.
  await file({path: '~/.backups', state: 'directory'});
  await file({path: '~/.config', state: 'directory'});
});

task('clone neovim', when('debian'), async () => {
  await file({path: '~/code', state: 'directory'});

  await command(
    'git',
    [
      'clone',
      '--branch',
      `v${NEOVIM_VERSION}`,
      '--depth',
      '1',
      'https://github.com/neovim/neovim.git',
    ],
    {
      chdir: '~/code',
      creates: '~/code/neovim',
      raw: true,
    },
  );
});

task('build neovim', when('debian'), async () => {
  await command('make', [
    'CMAKE_BUILD_TYPE=Release',
    'CMAKE_INSTALL_PREFIX=/usr/local',
  ], {
    chdir: '~/code/neovim',
    creates: '~/code/neovim/build/bin/nvim',
  });

  await command('make', ['install'], {
    chdir: '~/code/neovim',
    creates: '/usr/local/bin/nvim',
    sudo: true,
  });
});

task('install tree-sitter CLI', when('debian'), async () => {
  const arch = is('arm64') ? 'arm64' : 'x64';
  const url =
    `https://github.com/tree-sitter/tree-sitter/releases/download/v${TREE_SITTER_VERSION}/tree-sitter-linux-${arch}.gz`;

  await fetch({
    dest: path.root.join('vendor/vm/tree-sitter.gz'),
    encoding: null,
    url,
  });

  await command('gunzip', ['-f', path.root.join('vendor/vm/tree-sitter.gz')], {
    creates: path.root.join('vendor/vm/tree-sitter'),
  });

  await file({
    path: '/usr/local/bin/tree-sitter',
    src: path.root.join('vendor/vm/tree-sitter'),
    state: 'file',
    sudo: true,
    mode: '0755',
  });
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

const CACHE = path.root.join('.cache/repos');

task('compile Command-T (Lua)', async () => {
  const base = CACHE.join('github/wincent/command-t');

  await command('make', [], {
    chdir: base,
    creates: base.join('lua/wincent/commandt/lib/commandt.so'),
  });
});

task('install Command-T (Lua)', async () => {
  const src = CACHE.join(
    'github/wincent/command-t/lua/wincent/commandt/lib/commandt.so',
  );
  const dest = path.aspect.join(
    'files/.config/nvim/pack/bundle/opt/command-t/lua/wincent/commandt/lib/commandt.so',
  );

  await file({
    path: dest,
    src,
    state: 'file',
  });
});

task('build shellbot', async () => {
  const base = CACHE.join('github/wincent/shellbot');

  await command('cargo', ['build', '--release'], {
    chdir: base,
    creates: base.join('target/release/shellbot'),
  });
});

task('install shellbot', async () => {
  const src = CACHE.join('github/wincent/shellbot/target/release/shellbot');
  const dest = path.aspect.join(
    'files/.config/nvim/pack/bundle/opt/shellbot/target/release',
  );

  await file({path: dest, recurse: true, state: 'directory'});

  await file({
    path: dest.join('shellbot'),
    src,
    state: 'file',
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
    ['--headless', '-u', 'NONE', '-N', '-c', `mkspell! ${spellfile} | quit`],
    {
      creates: `${spellfile}.spl`,
    },
  );
});

task('update help tags', async () => {
  await command(resource.support('update-help-tags'), []);
});

task('install treesitter parsers', async () => {
  await command(resource.support('install-treesitter-parsers'), []);
});

// On my work machine, I divide my Corpus notes into two folders: one is
// work-specific, synced via Google Drive, and the other has personal notes
// in it and is not synced. Because Google Drive isn't good at handling Git
// directories, I store that elsewhere, and it doesn't get synced.
task('create Corpus directories', when('wincent', 'work'), async () => {
  // Corporate Corpus files go here.
  await file({
    path: '~/Documents/Corporate/Corpus',
    recurse: true,
    state: 'directory',
  });

  // Git directory goes under `~/Library/Application Support/Corpus`, with
  // subdirectories of the form "$HOME-relative path to Corpus files" and a
  // `.git` extension.
  await file({
    path: '~/Library/Application Support/Corpus/Documents/Corporate/Corpus.git',
    recurse: true,
    state: 'directory',
  });

  await command(
    'git',
    [
      'init',
      `--separate-git-dir=${
        path.home.join(
          'Library/Application Support/Corpus/Documents/Corporate/Corpus.git',
        )
      }`,
    ],
    {
      chdir: '~/Documents/Corporate/Corpus',
      creates: '~/Documents/Corporate/Corpus/.git',
    },
  );

  await file({
    path: '~/Documents/Personal/Corpus',
    recurse: true,
    state: 'directory',
  });

  await command('git', ['init'], {
    chdir: '~/Documents/Personal',
    creates: '~/Documents/Personal/.git',
  });
});

// added in 1a9f9b9fd and probably not used since...
// pip2 install vim-vint

// For masochist autocompleter
// pip3 install redis
