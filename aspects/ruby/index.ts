import {command, task} from 'fig';

task('install prefnerd', async () => {
    await command('gem', ['install', 'prefnerd'], {
        creates: '/usr/local/bin/pn',
        sudo: true,
    });
});
