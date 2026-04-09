import {command, fail, file, skip, task, variable} from 'fig';

task('update package index', async () => {
  await command('apt-get', ['update'], {sudo: true});
});

task('install packages', async () => {
  for (const pkg of variable.strings('packages')) {
    const result = await command(
      'dpkg-query',
      ['--show', '--showformat=${db:Status-Status}', pkg],
      {failedWhen: () => false},
    );

    if (result?.status !== 0 || result?.stdout.includes('not-installed')) {
      await command('apt-get', ['install', '-y', pkg], {sudo: true});
    } else if (result?.status === 0 && result?.stdout.includes('installed')) {
      await skip(`${pkg} is already installed`);
    } else {
      fail(`cannot determine installation status for ${pkg}`);
    }
  }
});

task('symlink fdfind to fd', async () => {
  // Command-T uses `fd`.
  //
  // On Debian, `fd` is installed as `fdfind` to avoid a conflict with `fdclone`
  // package (which also wants to install `fd`), but we don't use that, so we
  // can just create a symlink.
  await file({
    force: true,
    path: '/usr/local/bin/fd',
    src: '/usr/bin/fdfind',
    state: 'link',
    sudo: true,
  });
});
