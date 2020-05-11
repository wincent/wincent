import {file, resource, task} from 'fig';
import path from 'fig/path.js';

task('make folders', async () => {
    const base = path('~/Library/Application Support/UserScripts');

    await file({path: base, state: 'directory'});

    for (const directory of resource.files('*')) {
        await file({path: base.join(directory.basename), state: 'directory'});
    }
});

task('link files', async () => {
    for (const src of resource.files('*/*.js')) {
        await file({
            path: path('~/Library/Application Support/UserScripts').join(
                ...src.last(2)
            ),
            src,
            state: 'link',
        });
    }
});
