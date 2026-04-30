import {
  command,
  fetch,
  file,
  handler,
  path,
  resource,
  task,
  template,
  variable,
} from 'fig';

const TMUX_VERSION = '3.6a';

function prependPath(dir: string) {
  const expanded = path(dir).expand.toString();
  if (!process.env.PATH?.includes(expanded)) {
    process.env.PATH = `${expanded}:${process.env.PATH}`;
  }
}

task('create directories', async () => {
  await file({path: '~/.zshenv.d', state: 'directory'});
});

task('fill templates', async () => {
  const templates = variable.paths('templates');

  for (const src of templates) {
    await template({
      path: path.home.join(src.strip('.erb')),
      src: path.aspect.join('templates', src),
    });
  }
});

task('configure sshd', async () => {
  await file({
    notify: 'restart ssh',
    path: '/etc/ssh/sshd_config.d/sandbox.conf',
    src: resource.file('etc/ssh/sshd_config.d/sandbox.conf'),
    state: 'file',
    sudo: true,
  });
});

handler('restart ssh', async () => {
  await command('systemctl', ['restart', 'ssh'], {sudo: true});
});

task('download rustup installer', async () => {
  await fetch({
    dest: 'vendor/vm/rustup-init.sh',
    mode: '0755',
    url: 'https://sh.rustup.rs',
  });
});

task('install Rust via rustup', async () => {
  await command('vendor/vm/rustup-init.sh', ['-y', '--no-modify-path'], {
    creates: '~/.cargo/bin/rustup',
  });
  prependPath('~/.cargo/bin');
});

task('download dprint installer', async () => {
  await fetch({
    dest: 'vendor/vm/install-fmt.sh',
    mode: '0755',
    url: 'https://dprint.dev/install.sh',
  });
});

task('install dprint', async () => {
  await command('vendor/vm/install-fmt.sh', [], {
    creates: '~/.dprint/bin/dprint',
  });
  prependPath('~/.dprint/bin');
});

task('download Claude Code installer', async () => {
  await fetch({
    dest: 'vendor/vm/claude-install.sh',
    mode: '0755',
    url: 'https://claude.ai/install.sh',
  });
});

task('install Claude Code', async () => {
  await command('vendor/vm/claude-install.sh', [], {
    creates: '~/.claude/local/bin/claude',
  });
  prependPath('~/.claude/local/bin');
});

task('clone tmux', async () => {
  await file({path: '~/code', state: 'directory'});

  await command(
    'git',
    [
      'clone',
      '--branch',
      TMUX_VERSION,
      '--depth',
      '1',
      'https://github.com/tmux/tmux.git',
    ],
    {
      chdir: '~/code',
      creates: '~/code/tmux',
      raw: true,
    },
  );
});

task('build tmux', async () => {
  await command('sh', ['autogen.sh'], {
    chdir: '~/code/tmux',
    creates: '~/code/tmux/configure',
  });

  // Don't pass "./configure" here because it will get noramlized to
  // "configure" and fail; pass an absolute path instead.
  await command('~/code/tmux/configure', [], {
    chdir: '~/code/tmux',
    creates: '~/code/tmux/Makefile',
  });

  await command('make', [], {
    chdir: '~/code/tmux',
    creates: '~/code/tmux/tmux',
  });

  await command('make', ['install'], {
    chdir: '~/code/tmux',
    creates: '/usr/local/bin/tmux',
    sudo: true,
  });
});
