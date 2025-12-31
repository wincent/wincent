import {file, helpers, task} from 'fig';

const {when} = helpers;

task('create ~/Backups', when('wincent', 'personal'), async () => {
  await file({path: '~/Backups', state: 'directory'});
});
