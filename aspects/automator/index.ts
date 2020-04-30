import {command, resource, task} from 'fig';
import path from 'fig/path.js';

task('create "Open in Terminal Vim.app"', async () => {
    const script = resource.support('Open in Terminal Vim.applescript');

    await command('osascript', [script], {
        creates: path.home.join('bin/Open in Terminal Vim.app'),
    });
});
