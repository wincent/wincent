import {command, helpers, task} from 'fig';

const {is} = helpers;

task('install gems', async () => {
  const gems = ['ripper-tags'];

  if (is('darwin')) {
    gems.push('prefnerd');
  }

  for (const gem of gems) {
    await command('gem', ['install', gem], {
      creates: `/usr/local/bin/${gem}`,
      sudo: true,
    });
  }
});
