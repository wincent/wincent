import {
  backup,
  command,
  fail,
  file,
  helpers,
  log,
  path,
  prompt,
  resource,
  task,
  template,
  variable,
  variables,
} from 'fig';

const {when} = helpers;

variables(({hostHandle, identity, platform}) => {
  return {
    // This one is because Kitty defines these names to be the same:
    //
    // - "alt", "opt", "option", "⌥" (ie. the small modifier key next to Control)
    // - "super", "cmd", "command", "⌘" (ie. the large modifier key next to Space)
    //
    // That is, the _documentation_ uses Mac-centric terminology rather than
    // Linux terminology, where the following would apply:
    //
    // - "alt" refers to the large modifier key next to Space.
    // - "super" refers to the small modifier key next to Control.
    //
    // In general I prefer to use the Linux-centric names everywhere, because at
    // least those are partially in common with the names used in Windows:
    //
    // - "alt" refers to the large modifier key next to Space.
    // - "windows" refers to the small modifier key next to Control.
    //
    // (Also, because Apple itself stopped writing the word "alt" on the its
    // "super" key some years ago.)
    //
    // For more info on modifier key names, see: https://wincent.dev/wiki/Modifier_keys
    //
    // Anyway, all this means that if you want to use the "alt" key (ie. the
    // large modifier key) for anything in Kitty and have it work the same way
    // on both platforms, you need to call it "alt" in your Linux config and
    // "cmd" on your macOS one. On Linux, "alt" _does_ refer to the large
    // modifier. On Darwin, only "cmd" does.
    //
    // Kitty's `macos_options_as_alt` setting doesn't help us here because it
    // appears to only affect the behavior of the "option" key (ie. it makes it
    // behave like "alt") but it does not actually _swap_ the functionality of
    // the other key, so the other key ("cmd") continues to behave like "cmd".
    kittyAlt: platform === 'darwin' ? 'cmd' : 'alt',

    gitGpgSign: identity === 'wincent',
    gitHostSpecificInclude: `host/${hostHandle}`,
    gitUserEmail: identity === 'wincent' ? 'greg@hurrell.net' : '',
    gitUserName: identity === 'wincent' ? 'Greg Hurrell' : '',
    gitHubUsername: identity === 'wincent' ? 'wincent' : '',
  };
});

task('check for decrypted files', when('wincent'), async () => {
  const result = await command('bin/crypt-status', [], {
    failedWhen: () => false,
  });

  if (result !== null) {
    const pending = result.status === 0
      ? result.stdout
        .trim()
        .split(/\n/)
        .filter((line) => line.length)
      : ['unable to determine encryption status for any file'];

    if (pending.length) {
      log.warn(
        `Files not yet decrypted:\n\n${pending.join('\n')}\n`,
      );

      if (!(await prompt.confirm('Continue anyway'))) {
        fail(`decrypted file check failed`);
      }
    }
  }
});

task('make directories', async () => {
  await file({path: '~/.backups', state: 'directory'});
  await file({path: '~/.bitcoin', state: 'directory'});
  await file({path: '~/.config', state: 'directory'});
  await file({mode: '0700', path: '~/.gnupg', state: 'directory'});
  await file({path: '~/.irssi', state: 'directory'});
  await file({path: '~/.mail', state: 'directory'});
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

task('zcompile shell files', async () => {
  const script = resource.support('compile-zwc');

  await command('zsh', [script]);
});

task('create ~/code/.editorconfig', when('wincent'), async () => {
  await file({path: '~/code', state: 'directory'});
  await template({
    path: '~/code/.editorconfig',
    src: resource.template('code/.editorconfig'),
  });
});

task('create ~/dd', when('wincent', 'work'), async () => {
  await file({
    path: '~/go/src/github.com/DataDog',
    recurse: true,
    state: 'directory',
  });
  await file({
    path: '~/dd',
    src: '~/go/src/github.com/DataDog',
    state: 'link',
  });
});

task('create ~/dd/.editorconfig', when('wincent', 'work'), async () => {
  await template({
    path: '~/dd/.editorconfig',
    src: resource.template('dd/.editorconfig'),
  });
});

task('install glow.yml', when('darwin'), async () => {
  // On other platforms, Glow will read from ~/.config/glow/glow.yml.
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
});
