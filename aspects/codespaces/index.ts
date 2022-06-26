import {command, file, line, path, skip, task, variable} from 'fig';
import stat from 'fig/fs/stat.js';

task('set "StreamLocalBindUnlink yes" in /etc/ssh/sshd_config', async () => {
  const result = await line({
    group: 'root',
    line: 'StreamLocalBindUnlink yes',
    owner: 'root',
    path: '/etc/ssh/sshd_config',
    regexp: /^(?:\s*#\s*)?StreamLocalBindUnlink\b/,
    sudo: true,
  });

  if (result === 'changed') {
    await command('pkill', ['-HUP', '-F', '/var/run/sshd.pid'], {sudo: true});
  } else {
    await skip('no need to send SIGHUP to sshd (no changes made)');
  }
});

task('symlink files', async () => {
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

task('fetch lotabout/skim.git', async () => {
  await command(
    'git',
    [
      'clone',
      '--branch',
      'v0.9.4', // Not a branch, but a tag (still works).
      '--depth',
      '1',
      'https://github.com/lotabout/skim.git',
    ],
    {
      chdir: 'vendor',
      creates: 'vendor/skim',
      raw: true,
    }
  );
});

task('build skim', async () => {
  await command('cargo', ['install', '--path', '.'], {
    chdir: 'vendor/skim',
    creates: 'vendor/skim/target/release/sk',
  });
});

task('install skim', async () => {
  await command('cp', ['vendor/skim/target/release/sk', '/usr/local/bin/'], {
    creates: '/usr/local/bin/sk',
    sudo: true,
  });
});

task('run ripper-tags', async () => {
  const stats = await stat('/workspaces/github');
  if (stats === null) {
    await skip('no repo exists');
  } else {
    await command('ripper-tags', ['-R', '--exclude=vendor'], {
      creates: '/workspaces/github/tags',
      chdir: '/workspaces/github',
    });
  }
});
