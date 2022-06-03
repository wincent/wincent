import {command, handler, helpers, line, task} from 'fig';

const {when} = helpers;

task('configure /etc/auto_master', when('wincent'), async () => {
  await line({
    notify: 'flush cache',
    path: '/etc/auto_master',
    regexp: /^\s*#?\s*\/net\s+/,
    sudo: true,
    line: '#/net\t\t\t-hosts\t\t-nobrowse,hidefromfinder,nosuid',
  });
});

handler('flush cache', async () => {
  await command('automount', ['-vc'], {sudo: true});
});
