import {attributes, command, task} from 'fig';

task('install gems', async () => {
  const gems = ['ripper-tags'];

  if (attributes.platform === 'darwin') {
    gems.push('prefnerd');
  }

  for (const gem of gems) {
    await command('gem', ['install', gem], {
      creates: `/usr/local/bin/${gem}`,
      sudo: true,
    });
  }
});
