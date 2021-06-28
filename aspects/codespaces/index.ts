import {command, file, line, path, skip, task} from 'fig';
import Context from 'fig/Context.js';

task('set "StreamLocalBindUnlink yes" in /etc/ssh/sshd_config', async () => {
  const changedCount = Context.counts.changed;

  // TODO: teach functions like this one to return something so that we don't
  // have to look at `Context.counts.changed` like this.
  await line({
    group: 'root',
    line: 'StreamLocalBindUnlink yes',
    owner: 'root',
    path: '/etc/ssh/sshd_config',
    regexp: /^(?:\s*#\s*)?StreamLocalBindUnlink\b/,
  });

  if (Context.counts.changed > changedCount) {
    await command('pkill', ['-HUP', '-xf', '/usr/sbin/sshd']);
  } else {
    skip('no need to send SIGHUP to sshd (no changes made)');
  }
});

task('symlink files', async () => {
  for (const src of ['.config/nvim/init-local.vim']) {
    await file({
      force: true,
      path: path.home.join(src),
      src: path.aspect.join('files', src),
      state: 'link',
    });
  }
});
