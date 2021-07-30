import {
  attributes,
  backup,
  command,
  fail,
  file,
  log,
  path,
  prompt,
  resource,
  skip,
  template,
  task,
  variable,
  variables,
} from 'fig';

variables(({hostHandle, identity}) => {
  return {
    gitHostSpecificInclude: `.gitconfig.d/${hostHandle}`,
    gitUserEmail: identity === 'wincent' ? 'greg@hurrell.net' : '',
    gitUserName: identity === 'wincent' ? 'Greg Hurrell' : '',
    gitHubUsername: identity === 'wincent' ? 'wincent' : '',
  };
});

task('check for decrypted files', async () => {
  if (variable('identity') === 'wincent') {
    const result = await command(
      'vendor/git-cipher/bin/git-cipher',
      ['status'],
      {
        failedWhen: () => false,
      }
    );

    if (result !== null) {
      if (result.status !== 0) {
        log.warn(`git-cipher status:\n\n${result.stdout}\n`);

        if (!(await prompt.confirm('Continue anyway'))) {
          fail(`decrypted file check failed`);
        }
      }
    }
  } else {
    skip();
  }
});

task('make directories', async () => {
  await file({path: '~/.backups', state: 'directory'});
  await file({path: '~/.config', state: 'directory'});
  await file({mode: '0700', path: '~/.gnupg', state: 'directory'});
  await file({path: '~/.irssi', state: 'directory'});
  await file({path: '~/.mail', state: 'directory'});

  if (variable('identity') === 'wincent') {
    await file({path: '~/code', state: 'directory'});
  }
});

task('move originals to ~/.backups', async () => {
  const files = [...variable.paths('files'), ...variable.paths('templates')];

  for (const file of files) {
    const src = file.strip('.erb');

    await backup({src});
  }
});

task('create symlinks', async () => {
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

task('fill templates', async () => {
  const templates = variable.paths('templates');

  for (const src of templates) {
    const executable = src.endsWith('.sh.erb') || src.includes('/bin/');
    await template({
      mode: executable ? '0755' : '0644',
      path: path.home.join(src.strip('.erb')),
      src: path.aspect.join('templates', src),
    });
  }
});

task('create ~/code/.editorconfig', async () => {
  if (variable('identity') === 'wincent') {
    await template({
      path: '~/code/.editorconfig',
      src: resource.template('code/.editorconfig'),
    });
  } else {
    skip();
  }
});

task('install glow.yml', async () => {
  // On other platforms, Glow will read from ~/.config/glow/glow.yml.
  if (attributes.platform === 'darwin') {
    await file({
      path: '~/Library/Preferences/glow',
      state: 'directory',
    });

    await file({
      force: true,
      path: '~/Library/Preferences/glow/glow.yml',
      src: path.aspect.join('files/Library/Preferences/glow/glow.yml'),
      state: 'link',
    });
  }
});
