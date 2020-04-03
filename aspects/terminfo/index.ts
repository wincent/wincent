import {command, file, resource, task, variable} from '../../src/Fig';

task('create target directory', async () => {
    await file({
        path: variable.string('terminfo_path'),
        state: 'directory',
    });
});

task('update terminfo files', async () => {
    for (const terminfo of resource.files('*.terminfo')) {
        await command('tic', '-o', variable.string('terminfo_path'), terminfo);
    }
});
