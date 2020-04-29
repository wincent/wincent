import {line, task} from 'fig';

task('add /usr/local/bin/zsh to /etc/shells', async () => {
    await line({
        group: 'wheel',
        line: '/usr/local/bin/zsh',
        owner: 'root',
        path: '/etc/shells',
        sudo: true,
    });
});
