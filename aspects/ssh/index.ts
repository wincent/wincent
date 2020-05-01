import {fail, file, resource, skip, task, template, variable} from 'fig';
import stat from 'fig/fs/stat.js';

task('create ~/.ssh', async () => {
    await file({
        mode: '0700',
        path: '~/.ssh',
        state: 'directory',
    });
});

task('install ~/.ssh/config', async () => {
    if (variable('identity') === 'wincent') {
        const src = resource.template('.ssh/config.erb');

        const stats = await stat(src);

        if (stats === null) {
            fail(
                `"${src}" does not exist; run "vendor/git-cipher/bin/git-cipher"`
            );
        } else if (stats instanceof Error) {
            throw stats;
        } else {
            await template({
                mode: '0600',
                path: '~/.ssh/config',
                src,
            });
        }
    } else {
        skip();
    }
});
