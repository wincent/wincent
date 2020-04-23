import {fetch, task} from 'fig';

task('download installation script', async () => {
    await fetch({
        dest: 'vendor/homebrew/install',
        url:
            'https://raw.githubusercontent.com/Homebrew/install/master/install',
    });
});
