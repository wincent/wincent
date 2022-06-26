import {command, file, path, resource, skip, template, task} from 'fig';

const node = path.root.join('bin/node');

task('make directories', async () => {
  await file({path: '~/.config', state: 'directory'});
  await file({path: '~/.config/karabiner', state: 'directory'});
  await file({path: '~/bin', state: 'directory'});
});

task('copy helper scripts', async () => {
  const scripts = ['bin/karabiner-boot.command', 'bin/karabiner-kill.command'];

  for (const script of scripts) {
    await file({
      force: true,
      mode: script.endsWith('.applescript') ? '0644' : '0755',
      path: path.home.join(script),
      src: resource.file(script),
      state: 'link',
    });
  }
});

task('test karabiner.json generator', async () => {
  const test = resource.support('karabiner-test.js');

  await command(node, [test]);
});

let config: string | undefined;

task('prepare karabiner.json', async () => {
  const script = resource.support('karabiner.js');

  const result = await command(node, [script, '--emit-karabiner-config']);

  if (result) {
    config = result.stdout;
  }
});

task('write karabiner.json', async () => {
  if (!config) {
    return await skip('no contents prepared for karabiner.json');
  }

  await template({
    path: '~/.config/karabiner/karabiner.json',
    src: resource.template('.config/karabiner/karabiner.json.erb'),
    variables: {config},
  });
});

// This is a bit random having this in here, but it's a dependency of our
// Hammerspoon set-up; should possibly move the related bit of that in here?
task('write karabiner-sudoers', async () => {
  await template({
    path: '/private/etc/sudoers.d/karabiner-sudoers',
    src: resource.template('karabiner-sudoers.erb'),
    sudo: true,
  });
});

task('build `dry` executable', async () => {
  await command('make', [], {
    chdir: path.aspect.join('support/dry'),
    creates: resource.support('dry/dry'),
  });
});

task('install `dry` executable', async () => {
  await command('make install', [], {
    chdir: path.aspect.join('support/dry'),
    creates: path.home.join('bin/dry'),
  });
});
