import {command, fetch, resource, skip, task, template} from 'fig';

task('download installation script', async () => {
    await fetch({
        dest: 'vendor/homebrew/install.sh',
        mode: '0755',
        url:
            'https://raw.githubusercontent.com/Homebrew/install/master/install.sh',
    });
});

task('install Homebrew', async () => {
    await command('vendor/homebrew/install.sh', [], {
        creates: '/usr/local/bin/brew',
    });
});

task('update Homebrew', async () => {
    await command('brew', ['update']);
});

task('tap "homebrew/bundle"', async () => {
    const result = await command('brew', ['tap']);

    if (/^homebrew\/bundle$/m.test(result!.stdout)) {
        return skip('already tapped');
    }

    await command('brew', ['tap', 'homebrew/bundle']);
});

task('prepare Brewfile', async () => {
    await template({
        path: '~/Library/Preferences/Brewfile',
        src: resource.template('Brewfile.erb'),
    });
});

task('run "brew bundle"', async () => {
    await command('brew', ['bundle'], {
        chdir: '~/Library/Preferences',
    });
});

task('clean up old versions', async () => {
    await command('brew', ['cleanup']);
});
