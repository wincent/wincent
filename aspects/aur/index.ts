import {command, file, handler, helpers, resource, skip, variable} from 'fig';
import {join} from 'path';

const {arch} = helpers;

arch.task('fetch yay', async () => {
  // TODO: make a `git` operation? (if I need to do this in more than one
  // place; second place has arrived now, in the vim aspect.)
  await command('git', ['clone', 'https://aur.archlinux.org/yay.git/'], {
    chdir: 'vendor',
    creates: 'vendor/yay',
    raw: true,
  });
});

arch.task('install yay', async () => {
  await command('makepkg', ['-si', '--noconfirm'], {
    chdir: 'vendor/yay',
    creates: '/usr/bin/yay',
  });
});

arch.task('install packages', async () => {
  await command('yay', ['-S', '--noconfirm', ...variable.strings('packages')]);
});

arch.task('create ~/.config/systemd/user', async () => {
  for (const directory of [
    '~/.config',
    '~/.config/systemd',
    '~/.config/systemd/user',
  ]) {
    await file({
      path: directory,
      state: 'directory',
    });
  }
});

arch.task('install ~/.config/systemd/user/clipper.service', async () => {
  await file({
    notify: 'enable clipper.service',
    path: '~/.config/systemd/user/clipper.service',
    src: '/usr/share/clipper/clipper.service',
    state: 'file',
  });
});

arch.task('set up sensors', async () => {
  for (const conf of [
    'etc/modprobe.d/it87.conf',
    'etc/modules-load.d/it87.conf',
    'etc/sensors.d/gigabyte-x570.conf',
  ]) {
    await file({
      path: join('/', conf),
      src: resource.file(conf),
      state: 'file',
      sudo: true,
    });
  }
});

arch.task('set Microsoft Edge as default browser', async () => {
  const result = await command('xdg-settings', [
    'check',
    'default-web-browser',
    'microsoft-edge.desktop',
  ]);

  if (result?.status === 0 && result.stdout.includes('yes')) {
    skip('already default');
  } else {
    await command('xdg-settings', [
      'set',
      'default-web-browser',
      'microsoft-edge.desktop',
    ]);
  }
});

handler('enable clipper.service', async () => {
  await command('systemctl', ['--user', 'daemon-reload']);
  await command('systemctl', ['--user', 'enable', 'clipper.service', '--now']);
});
