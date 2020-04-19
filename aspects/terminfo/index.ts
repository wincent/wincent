import {command, file, resource, task, variable} from '../../src/Fig/index.js';

task('create target directory', async () => {
    await file({
        path: variable.string('terminfoPath'),
        state: 'directory',
    });
});

task('update terminfo files', async () => {
    for (const terminfo of resource.files('*.terminfo')) {
        await command('tic', ['-o', variable.string('terminfoPath'), terminfo]);
    }
});
