import {task, line, variable} from 'fig';

task('set up /etc/locale.conf', async () => {
  for (const setting of variable.strings('lines')) {
    const [key] = setting.split('=');

    await line({
      group: 'wheel',
      line: setting,
      owner: 'root',
      path: '/etc/locale.conf',
      regexp: key,
      sudo: true,
    });
  }
});
