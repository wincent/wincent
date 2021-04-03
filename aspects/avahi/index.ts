import {command, fail, file, task} from 'fig';

task('enable avahi-daemon', async () => {
    // TODO: refactor this because I have almost identical code in sshd aspect
    const result = await command('systemctl', ['is-active', 'avahi-daemon'], {
        failedWhen: () => false,
    });

    if (result && typeof result.status === 'number') {
        if (result.status !== 0) {
            await command('systemctl', ['start', 'avahi-daemon.service'], {
                sudo: true,
            });
        }
    } else {
        fail('could not determine avahi-daemon status');
    }
});

task('enable /etc/services/avahi/ssh.service', async () => {
    await file({
        path: '/etc/avahi/services/ssh.service',
        src: '/usr/share/doc/avahi/ssh.service',
        state: 'file',
        sudo: true,
    });
});
