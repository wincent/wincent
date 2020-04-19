import {command, file, template, task, variable} from '../../src/Fig/index.js';
import assert from '../../src/assert.js';
import stat from '../../src/fs/stat.js';
import path from '../../src/path.js';

task('make directories', async () => {
    await file({path: '~/.backups', state: 'directory'});
    await file({path: '~/.config', state: 'directory'});
    await file({path: '~/.config/karabiner', state: 'directory'});
    await file({path: '~/.zshenv.d', state: 'directory'});
});

task('link ~/.config/nvim to ~/.vim', async () => {
    await file({
        path: '~/.config/nvim',
        src: '~/.vim',
        state: 'link',
    });
});

task('copy to ~/backups', async () => {
    const files = [...variable.array('files'), ...variable.array('templates')];

    for (const file of files) {
        assert(typeof file === 'string');

        const base = path(file).basename;
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
    const files = variable.array('files');

    for (const src of files) {
        assert(typeof src === 'string');

        await file({
            force: true,
            path: path.home.join(path(src).basename),
            src: path.aspect().join('files', path(src).basename),
            state: 'link',
        });
    }
});

task('fill templates', async () => {
    // TODO: map path already here (and above)
    const templates = variable.array('templates');

    for (const src of templates) {
        assert(typeof src === 'string');

        await template({
            mode: src.endsWith('.sh.erb') ? '0755' : '0644',
            path: path.home.join(path(src).basename.strip('.erb')),
            src: path.aspect().join('templates', path(src).basename),
        });
    }
});
