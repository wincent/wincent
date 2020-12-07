import {
    attributes,
    command,
    line,
    skip,
    task as defineTask,
    variable,
} from 'fig';

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
    await command('pacman', ['-Syy'], {sudo: true});
});

task('install packages', async () => {
    // TODO: make this check rather than running unconditionally?
    await command(
        'pacman',
        ['-S', '--noconfirm', ...variable.strings('packages')],
        {
            sudo: true,
        }
    );
});

task('run updatedb', async () => {
    await command('updatedb', [], {sudo: true});
});

// Tweaks: should be moved into separate aspects.
task('configure faillock.conf', async () => {
    await line({
        path: '/etc/security/faillock.conf',
        regexp: /^\s*#?\s*deny\s*=/,
        sudo: true,
        line: 'deny = 10',
    });

    await line({
        path: '/etc/security/faillock.conf',
        regexp: /^\s*#?\s*unlock_time\s*=/,
        sudo: true,
        line: 'unlock_time = 60',
    });
});
