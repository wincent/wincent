import {command, fetch, file, path, task, template, variable} from 'fig';

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
});
