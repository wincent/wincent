import {attributes, command, skip, task as defineTask, variable} from 'fig';

// TODO: DRY this up; it is in three files now
function task(name: string, callback: () => Promise<void>) {
    defineTask(name, async () => {
        if (attributes.distribution === 'arch') {
            await callback();
        } else {
            skip('not on Arch Linux');
        }
    });
}

task('fetch yay', async () => {
    // TODO: make a `git` operation? (if I need to do this in more than one
    // place)
    await command('git', ['clone', 'https://aur.archlinux.org/yay.git/'], {
        chdir: 'vendor',
        creates: 'vendor/yay',
        raw: true,
    });
});

task('install yay', async () => {
    await command('makepkg', ['-si', '--noconfirm'], {
        chdir: 'vendor/yay',
        creates: '/usr/bin/yay',
    });
});

task('install packages', async () => {
    await command('yay', [
        '-S',
        '--noconfirm',
        ...variable.strings('packages'),
    ]);
});
