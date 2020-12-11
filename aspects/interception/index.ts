import {
    attributes,
    command,
    handler,
    resource,
    skip,
    task as defineTask,
    template,
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

task('create /etc/dual-function-keys.yaml', async () => {
    await template({
        notify: 'enable udevmon',
        path: '/etc/dual-function-keys.yaml',
        src: resource.template('dual-function-keys.yaml.erb'),
        sudo: true,
    });
});

task('create /etc/udevmon.yaml', async () => {
    await template({
        notify: 'enable udevmon',
        path: '/etc/udevmon.yaml',
        src: resource.template('udevmon.yaml.erb'),
        sudo: true,
    });
});

handler('enable udevmon', async () => {
    await command('systemctl', ['enable', 'udevmon', '--now'], {
        sudo: true,
    });
});
