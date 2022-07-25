import {command, fail, handler, line, task} from 'fig';

task('disable password-based authentication', async () => {
  await line({
    line: 'PasswordAuthentication no',
    notify: 'restart sshd.service',
    path: '/etc/ssh/sshd_config',
    regexp: /\s*#?\s*PasswordAuthentication\s+(?:yes|no)\b/,
    sudo: true,
  });
});

task(
  'set "StreamLocalBindUnlink yes" in /etc/ssh/sshd_config (systemd)',
  async () => {
    await line({
      line: 'StreamLocalBindUnlink yes',
      notify: 'restart sshd.service',
      path: '/etc/ssh/sshd_config',
      regexp: /^(?:\s*#\s*)?StreamLocalBindUnlink\b/,
      sudo: true,
    });
  }
);

task('activate sshd', async () => {
  const result = await command('systemctl', ['is-active', 'sshd'], {
    failedWhen: () => false,
  });

  if (result && typeof result.status === 'number') {
    if (result.status !== 0) {
      await command('systemctl', ['start', 'sshd.service'], {sudo: true});
    }
  } else {
    fail('could not determine sshd status');
  }
});

task('enable sshd', async () => {
  const result = await command('systemctl', ['is-enabled', 'sshd'], {
    failedWhen: () => false,
  });

  if (result && typeof result.status === 'number') {
    if (result.status !== 0) {
      await command('systemctl', ['enable', 'sshd.service'], {
        sudo: true,
      });
    }
  } else {
    fail('could not determine sshd status');
  }
});

handler('restart sshd.service', async () => {
  await command('systemctl', ['restart', 'sshd.service'], {sudo: true});
});
