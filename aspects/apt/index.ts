import {command, fail, helpers, skip, variable} from 'fig';

const {debian} = helpers;

debian.task('install packages', async () => {
  for (const pkg of variable.strings('packages')) {
    const result = await command(
      'dpkg-query',
      ['--show', '--showformat=${db:Status-Status}', pkg],
      {failedWhen: () => false}
    );

    if (result?.status !== 0 || result?.stdout.includes('not-installed')) {
      await command('apt-get', ['install', '-y', pkg]);
    } else if (result?.status === 0 && result?.stdout.includes('installed')) {
      skip(`${pkg} is already installed`);
    } else {
      fail(`cannot determine installation status for ${pkg}`);
    }
  }
});
