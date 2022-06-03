import {command, fail, helpers, skip, task, variable} from 'fig';

const {when} = helpers;

task('install packages', when('debian'), async () => {
  for (const pkg of variable.strings('packages')) {
    const result = await command(
      'dpkg-query',
      ['--show', '--showformat=${db:Status-Status}', pkg],
      {failedWhen: () => false}
    );

    if (result?.status !== 0 || result?.stdout.includes('not-installed')) {
      await command('apt-get', ['install', '-y', pkg], {sudo: true});
    } else if (result?.status === 0 && result?.stdout.includes('installed')) {
      skip(`${pkg} is already installed`);
    } else {
      fail(`cannot determine installation status for ${pkg}`);
    }
  }
});
