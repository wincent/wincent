import {basename, join} from 'path';

import expand from '../../src/path/expand.js';

import {
    command,
    resource,
    file,
    // template,
    task,
} from '../../src/Fig/index.js';
import stat from '../../src/fs/stat.js';

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
        const base = basename(file);
        const source = expand(`~/${base}`);
        const target = join(expand('~/.backups'), base);

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
            path: expand(`~/${basename(src)}`),
            src,
            state: 'link',
        });
    }
});
