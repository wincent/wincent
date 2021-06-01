import {
  attributes,
  command,
  file,
  handler,
  resource,
  skip,
  task as defineTask,
  template,
} from 'fig';

function task(name: string, callback: () => Promise<void>) {
  defineTask(name, async () => {
    if (attributes.distribution === 'arch') {
      await callback();
    } else {
      skip('not on Arch Linux');
    }
  });
}

task('build mac2linux', async () => {
  const chdir = resource.support();

  await command('cmake', ['--build', '.'], {chdir});
  await command('make', [], {chdir});
});

task('install mac2linux', async () => {
  const chdir = resource.support();

  await command('cmake', ['--install', '.', '--prefix', '/usr'], {
    chdir,
    notify: 'enable udevmon',
    sudo: true,
  });
});

task('create /etc/interception', async () => {
  await file({
    path: '/etc/interception',
    state: 'directory',
    sudo: true,
  });
});

task('create /etc/interception/dual-function-keys.yaml', async () => {
  await template({
    notify: 'enable udevmon',
    path: '/etc/interception/dual-function-keys.yaml',
    src: resource.template('dual-function-keys.yaml.erb'),
    sudo: true,
  });
});

task('create /etc/interception/udevmon.yaml', async () => {
  await template({
    notify: 'enable udevmon',
    path: '/etc/interception/udevmon.yaml',
    src: resource.template('udevmon.yaml.erb'),
    sudo: true,
  });
});

handler('enable udevmon', async () => {
  await command('systemctl', ['enable', 'udevmon', '--now'], {
    sudo: true,
  });
});
