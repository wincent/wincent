import {attributes, command, file, resource, skip, task, variable} from 'fig';
import stat from 'fig/fs/stat.js';
import path from 'fig/path.js';

task('make directories', async () => {
    // Some overlap with "dotfiles" aspect here.
    await file({path: '~/.backups', state: 'directory'});
    await file({path: '~/.config', state: 'directory'});
});

task('link ~/.config/nvim to ~/.vim', async () => {
    await file({
        path: '~/.config/nvim',
        src: '~/.vim',
        state: 'link',
    });
});

task('copy to ~/backups', async () => {
    // Some overlap with "dotfiles" aspect here (may want to look at
    // abstracting backups somehow.
    // TODO: make a "backup" DSL that copies files to standard location
    // could also be a switch to "file", "template" DSLs but I don't like that
    // idea as much
    const files = variable.paths('files');

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
    // Some overlap with "dotfiles" aspect here.
    const files = variable.paths('files');

    for (const src of files) {
        await file({
            force: true,
            path: path.home.join(src.basename),
            src: path.aspect.join('files', src.basename),
            state: 'link',
        });
    }
});

const COMMAND_T_BASE = 'pack/bundle/opt/command-t/ruby/command-t/ext/command-t';

task('configure Command-T', async () => {
    const base = resource.file('.vim').join(COMMAND_T_BASE);

    await command('ruby', ['extconf.rb'], {
        chdir: base,
        creates: base.join('Makefile'),
    });
});

task('compile Command-T', async () => {
    const bundle = attributes.platform === 'darwin' ? 'ext.bundle' : 'ext.so';
    const base = resource.file('.vim').join(COMMAND_T_BASE);

    await command('make', [], {
        chdir: base,
        creates: base.join(bundle),
    });
});

task('update bundle', async () => {
    skip('not yet implemented');
});
