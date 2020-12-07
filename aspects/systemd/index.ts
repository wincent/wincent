import {attributes, command, skip, task as defineTask, variable} from 'fig';

// TODO: need to come up with a better pattern for arch-specific stuff
function task(name: string, callback: () => Promise<void>) {
    defineTask(name, async () => {
        if (attributes.distribution === 'arch') {
            await callback();
        } else {
            skip('not on Arch Linux');
        }
    });
}

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
