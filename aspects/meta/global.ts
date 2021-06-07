import {file, root, task} from 'fig';

task('set repo permissions', async () => {
  await file({
    mode: '0700',
    path: root,
    state: 'directory',
  });
});
