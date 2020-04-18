import {
    // resource,
    file,
    // template,
    task,
} from '../../src/Fig/index.js';

task('make config directories', async () => {
    const directories = [
        '~/.config',
        '~/.config/alacritty',
        '~/.config/karabiner',
    ];

    for (const path of directories) {
        await file({
            path,
            state: 'directory',
        });
    }
});
