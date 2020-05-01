import {file, task} from 'fig';

task('create ~/Backups', async () => {
    await file({path: '~/Backups', state: 'directory'});
});
