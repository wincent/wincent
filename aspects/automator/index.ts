import {command, path, resource, task} from 'fig';

task('create "Open in Terminal Vim.app"', async () => {
    const script = resource.support('Open in Terminal Vim.applescript');
    const contents = resource.support('Open in Terminal Vim.js');

    await command('osascript', [script, contents], {
        creates: path.home.join('bin/Open in Terminal Vim.app'),
    });
});
