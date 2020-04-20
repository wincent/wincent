import {
    command,
    file,
    resource,
    template,
    task,
    variable,
    variables,
} from '../../src/Fig.js';
import stat from '../../src/fs/stat.js';
import path from '../../src/path.js';

variables(({identity}) => ({
    gitUserEmail: identity === 'wincent' ? 'greg@hurrell.net' : '',
    gitUserName: identity === 'wincent' ? 'Greg Hurrell' : '',
    gitHubUsername: identity === 'wincent' ? 'wincent' : '',
}));

task('make directories', async () => {
    await file({path: '~/.backups', state: 'directory'});
    await file({path: '~/.config', state: 'directory'});
    await file({path: '~/.config/karabiner', state: 'directory'});
    await file({path: '~/.mail', state: 'directory'});
    await file({path: '~/.zshenv.d', state: 'directory'});

    if (variable('identity') === 'wincent') {
        await file({path: '~/code', state: 'directory'});
    }
});

task('copy to ~/backups', async () => {
    const files = [...variable.paths('files'), ...variable.paths('templates')];

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

task('fill templates', async () => {
    const templates = variable.paths('templates');

    for (const src of templates) {
        await template({
            mode: src.endsWith('.sh.erb') ? '0755' : '0644',
            path: path.home.join(src.basename.strip('.erb')),
            src: path.aspect.join('templates', src.basename),
        });
    }
});

task('create ~/code/.editorconfig', async () => {
    if (variable('identity') === 'wincent') {
        await template({
            path: path.home.join('code/.editorconfig'),
            src: resource.template('code/.editorconfig'),
        });
    }
});
