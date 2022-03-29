import {command, file, handler, helpers, resource, template} from 'fig';

const {arch} = helpers;

arch.task('build mac2linux', async () => {
  const chdir = resource.support();

  await command('cmake', ['--build', '.'], {chdir});
  await command('make', [], {chdir});
});

arch.task('install mac2linux', async () => {
  const chdir = resource.support();

  await command('cmake', ['--install', '.', '--prefix', '/usr'], {
    chdir,
    notify: 'enable udevmon',
    sudo: true,
  });
});

arch.task('create /etc/interception', async () => {
  await file({
    path: '/etc/interception',
    state: 'directory',
    sudo: true,
  });
});

arch.task('create /etc/interception/dual-function-keys.yaml', async () => {
  await template({
    notify: 'enable udevmon',
    path: '/etc/interception/dual-function-keys.yaml',
    src: resource.template('dual-function-keys.yaml.erb'),
    sudo: true,
  });
});

arch.task('create /etc/interception/udevmon.yaml', async () => {
  await template({
    notify: 'enable udevmon',
    path: '/etc/interception/udevmon.yaml',
    src: resource.template('udevmon.yaml.erb'),
    sudo: true,
  });
});

// This being in here is semi-sketchy because it isn't strictly related to
// Interception Tools, but it _is_ related to the keyboard and udev, so we
// put it here. Depends on scripts installed by the dotfiles aspect, so the
// separation of concerns is unclear.
arch.task('create /etc/udev/rules.d/50-realforce-layout.rules', async () => {
  await template({
    notify: 'reload udevadm',
    path: '/etc/udev/rules.d/50-realforce-layout.rules',
    src: resource.template('50-realforce-layout.rules.erb'),
    sudo: true,
  });
});

handler('enable udevmon', async () => {
  await command('systemctl', ['enable', 'udevmon', '--now'], {
    sudo: true,
  });
});

handler('reload udevadm', async () => {
  await command('udevadm', ['control', '--reload'], {
    sudo: true,
  });
});
