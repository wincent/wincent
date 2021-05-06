import {file, skip, task, variable} from 'fig';

task('create ~/Backups', async () => {
  if (variable('identity') === 'wincent') {
    await file({path: '~/Backups', state: 'directory'});
  } else {
    skip();
  }
});
