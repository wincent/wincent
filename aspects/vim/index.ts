import {
    attributes,
    backup,
    command,
    file,
    path,
    resource,
    skip,
    task,
    variable,
} from 'fig';

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

task('move originals to ~/.backups', async () => {
    const files = variable.paths('files');

    for (const src of files) {
        await backup({src});
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

task('create spell file', async () => {
    const spellfile = path.aspect.join('files/.vim/spell/en.utf-8.add');

    await command(
        'nvim',
        ['-u', 'NONE', '-N', '-c', `mkspell! ${spellfile} | quit`],
        {
            creates: `${spellfile}.spl`,
        }
    );
});

task('update bundle', async () => {
    skip('not yet implemented');
    // update-bundle
});

task('update help tags', async () => {
    await command(resource.support('update-help-tags'), []);
});

task('install neovim gem', async () => {
    await command('gem', ['install', 'neovim']);
});

task('install typescript-language-server', async () => {
  await command('yarn', ['global', 'add', 'typescript-language-server']);
});

// added in 1a9f9b9fd and probably not used since...
// pip2 install vim-vint

// optional: just allows us to release updates to deoplete sorter
// pip3 install twine

// for custom deoplete sorters
// pip3 install commandt.score

// for deoplete
// pip3 install msgpack

// general python support for neovim
// pip3 install --upgrade pynvim

// legacy way (commented out) was:
// pip2 install neovim
// pip3 install neovim -- not sure if still needed

// For masochist autocompleter
// pip3 install redis
