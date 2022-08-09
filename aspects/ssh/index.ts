import {
  file,
  helpers,
  log,
  path,
  resource,
  skip,
  task,
  template,
  variable,
} from 'fig';

const {isDecrypted, when} = helpers;

task('create ~/.ssh/* directories', async () => {
  for (const directory of [
    '~/.ssh',
    '~/.ssh/config.d',
    '~/.ssh/config.d/post',
    '~/.ssh/config.d/pre',
  ]) {
    await file({
      mode: '0700',
      path: directory,
      state: 'directory',
    });
  }
});

task('create ~/.ssh', async () => {
  await file({
    mode: '0700',
    path: '~/.ssh',
    state: 'directory',
  });
});

task('install ~/.ssh/config', when('wincent'), async () => {
  const src = resource.template('.ssh/config.erb');
  const decrypted = await isDecrypted(src);

  if (!decrypted) {
    await log.warn(`"${src}" does not exist; run "bin/git-cipher unlock"`);
  } else {
    await template({
      mode: '0600',
      path: '~/.ssh/config',
      src,
    });
  }
});

task('install host-specific to ~/.ssh/config/config.d/*', async () => {
  for (const directory of ['pre', 'post']) {
    const hostHandle = variable.string('hostHandle');
    const src = resource.file('.ssh/config.d').join(directory, hostHandle);
    const decrypted = await isDecrypted(src);

    if (decrypted) {
      await file({
        force: true,
        path: path.home.join('.ssh/config.d', directory, hostHandle),
        src,
        state: 'link',
      });
    } else {
      await skip(`no per-host ${directory} config for ${hostHandle}`);
    }
  }
});
