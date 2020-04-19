import {
    command,
    resource,
    file,
    // template,
    task,
} from '../../src/Fig/index.js';
import stat from '../../src/fs/stat.js';
import path from '../../src/path.js';

task('make config directories', async () => {
    await file({path: '~/.config', state: 'directory'});
    await file({path: '~/.config/karabiner', state: 'directory'});
});

task('link ~/.config/nvim to ~/.vim', async () => {
    await file({
        path: '~/.config/nvim',
        src: '~/.vim',
        state: 'link',
    });
});

task('make ~/.backups', async () => {
    await file({
        path: '~/.backups',
        state: 'directory',
    });
});

task('copy to ~/backups', async () => {
    const files = resource.files('*');

    for (const file of files) {
        const base = file.basename;
        const source = path.home.join(base);
        const target = path.home.join('.backups', base);

        const stats = await stat(source);

        if (stats instanceof Error) {
            throw stats;
        } else if (!stats) {
            continue;
        } else if (stats.type === 'directory' || stats.type === 'file') {
            await command('mv', ['-f', source, target], {
                creates: target,
            });
        }
    }
});

task('create symlinks', async () => {
    const files = resource.files('*');

    for (const src of files) {
        await file({
            force: true,
            path: path.home.join(src.basename),
            src,
            state: 'link',
        });
    }
});
