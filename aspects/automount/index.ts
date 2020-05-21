import {command, handler, line, skip, task, variable} from 'fig';

task('configure /etc/auto_master', async () => {
    if (variable('identity') === 'wincent') {
        await line({
            notify: 'flush cache',
            path: '/etc/auto_master',
            regexp: /^\s*#?\s*\/net\s+/,
            sudo: true,
            line: '#/net\t\t\t-hosts\t\t-nobrowse,hidefromfinder,nosuid',
        });
    } else {
        skip();
    }
});

handler('flush cache', async () => {
    await command('automount', ['-vc'], {sudo: true});
});
