import {command, skip, task, variable} from 'fig';

task('set up hostname', async () => {
    const hostname = variable.string('hostname');
    const result = await command('hostname', []);

    if (
        variable('identity') === 'wincent' &&
        result!.stdout.trim() !== hostname
    ) {
        await command('hostnamectl', ['set-hostname', hostname]);
    } else {
        skip();
    }
});
