import {
    command,
    fail,
    file,
    options,
    resource,
    skip,
    template,
    task,
    variable,
    variables,
} from 'fig';
import {log} from 'fig/console.js';
import stat from 'fig/fs/stat.js';
import path from 'fig/path.js';
import mkdir from 'fig/posix/mkdir.js';

variables(({identity}) => ({
    gitUserEmail: identity === 'wincent' ? 'greg@hurrell.net' : '',
    gitUserName: identity === 'wincent' ? 'Greg Hurrell' : '',
    gitHubUsername: identity === 'wincent' ? 'wincent' : '',
}));

task('check for decrypted files', async () => {
    if (variable('identity') === 'wincent') {
        const result = await command(
            'vendor/git-cipher/bin/git-cipher',
            ['status'],
            {
                failedWhen: () => false,
            }
        );

        if (result !== null) {
            if (result.status !== 0) {
                log.warn(`git-cipher status:\n\n${result.stdout}\n`);

                fail(`decrypted file check failed`);
            }
        }
    } else {
        skip();
    }
});

task('make directories', async () => {
    await file({path: '~/.backups', state: 'directory'});
    await file({path: '~/.config', state: 'directory'});
    await file({path: '~/.mail', state: 'directory'});
    await file({path: '~/.zshenv.d', state: 'directory'});

    if (variable('identity') === 'wincent') {
        await file({path: '~/code', state: 'directory'});
    }
});

// TODO: again see if there is anything common to factor out here
task('move originals to ~/backups', async () => {
    const files = [...variable.paths('files'), ...variable.paths('templates')];

    for (const file of files) {
        const stripped = file.strip('.erb');
        const backups = path.home.join('.backups');
        const source = path.home.join(stripped);
        const target = path.home.join('.backups', stripped);

        const stats = await stat(source);

        if (stats instanceof Error) {
            throw stats;
        } else if (!stats) {
            continue;
        } else if (stats.type === 'directory' || stats.type === 'file') {
            // Create parent directories if necessary.
            if (!options.check) {
                const result = await mkdir(backups.join(file.dirname).expand, {
                    intermediate: true,
                });

                if (result instanceof Error) {
                    throw result;
                }

                await command('mv', ['-f', source, target], {
                    creates: target,
                });
            } else {
                skip(`file ${stripped}`);
            }
        }
    }
});

task('create symlinks', async () => {
    const files = variable.paths('files');

    for (const src of files) {
        await file({
            force: true,
            path: path.home.join(src),
            src: path.aspect.join('files', src),
            state: 'link',
        });
    }
});

task('fill templates', async () => {
    const templates = variable.paths('templates');

    for (const src of templates) {
        await template({
            mode: src.endsWith('.sh.erb') ? '0755' : '0644',
            path: path.home.join(src.strip('.erb')),
            src: path.aspect.join('templates', src),
        });
    }
});

task('create ~/code/.editorconfig', async () => {
    if (variable('identity') === 'wincent') {
        await template({
            path: '~/code/.editorconfig',
            src: resource.template('code/.editorconfig'),
        });
    } else {
        skip();
    }
});
