import {command, file, line, path, skip, task, variable} from 'fig';

task('set "StreamLocalBindUnlink yes" in /etc/ssh/sshd_config', async () => {
  const result = await line({
    group: 'root',
    line: 'StreamLocalBindUnlink yes',
    owner: 'root',
    path: '/etc/ssh/sshd_config',
    regexp: /^(?:\s*#\s*)?StreamLocalBindUnlink\b/,
  });

  if (result === 'changed') {
    await command('pkill', ['-HUP', '-F', '/var/run/sshd.pid']);
  } else {
    skip('no need to send SIGHUP to sshd (no changes made)');
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
