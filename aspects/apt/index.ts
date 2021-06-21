import {
  attributes,
  command,
  fail,
  skip,
  task as defineTask,
  variable,
} from 'fig';

function task(name: string, callback: () => Promise<void>) {
  defineTask(name, async () => {
    if (attributes.distribution === 'debian') {
      await callback();
    } else {
      skip('not on Debian');
    }
  });
}

task('install packages', async () => {
  for (const pkg of variable.strings('packages')) {
    const result = await command('dpkg-query', [
      '--show',
      '--showformat=${db:Status-Status}',
      pkg,
    ]);

    if (result?.status !== 0 || result?.stdout.includes('not-installed')) {
      await command('apt-get', ['install', '-y', pkg]);
    } else if (result?.status === 0 && result?.stdout.includes('installed')) {
      skip(`${pkg} is already installed`);
    } else {
      fail(`cannot determine installation status for ${pkg}`);
    }
  }
});
