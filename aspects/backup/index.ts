import {file, helpers} from 'fig';

const {wincent} = helpers;

wincent.task('create ~/Backups', async () => {
  await file({path: '~/Backups', state: 'directory'});
});
