import {attributes, command, skip, task as defineTask, variable} from 'fig';

function task(name: string, callback: () => Promise<void>) {
    defineTask(name, async () => {
        if (attributes.distribution === 'arch') {
            await callback();
        } else {
            skip('not on Arch Linux');
        }
    });
}

task('refresh package databases', async () => {
    await command('pacman', ['-Syy']);
});

task('install packages', async () => {
    await command('pacman', ['-S', ...variable.strings('packages')]);
});
