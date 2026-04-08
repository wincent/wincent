import {command, helpers, line, task, variable} from 'fig';

const {is, when} = helpers;

task('generate locales', when('debian'), async () => {
  for (const locale of variable.strings('locales')) {
    await line({
      group: 'root',
      line: locale,
      owner: 'root',
      path: '/etc/locale.gen',
      regexp: locale,
      sudo: true,
    });
  }

  await command('locale-gen', [], {sudo: true});
});

task('set up /etc/locale.conf', async () => {
  for (const setting of variable.strings('lines')) {
    const [key] = setting.split('=');

    await line({
      group: is('debian') ? 'root' : 'wheel',
      line: setting,
      owner: 'root',
      path: '/etc/locale.conf',
      regexp: key,
      sudo: true,
    });
  }
});
