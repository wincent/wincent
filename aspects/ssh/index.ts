import {
  fail,
  file,
  helpers,
  path,
  resource,
  skip,
  task,
  template,
  variable,
} from 'fig';
import stat from 'fig/fs/stat.js';

const {when} = helpers;

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

  const stats = await stat(src);

  // TODO: make this warn instead of fail
  // (on first run on a new machine, we might not have decrypted yet...
  // because we won't have the GPG key on the machine yet...
  // although maybe I should just do that...)
  if (stats === null) {
    fail(`"${src}" does not exist; run "bin/git-cipher"`);
  } else if (stats instanceof Error) {
    throw stats;
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
    const stats = await stat(src);

    if (stats && !(stats instanceof Error)) {
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
