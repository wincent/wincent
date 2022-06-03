import {command, file, helpers, resource, task} from 'fig';

const {is} = helpers;

task('create target directory', async () => {
  if (is('linux')) {
    await file({path: '~/share', state: 'directory'});
    await file({path: '~/share/terminfo', state: 'directory'});
  } else {
    await file({path: '~/.terminfo', state: 'directory'});
  }
});

task('update terminfo files', async () => {
  let terminfoPath: string;

  if (is('linux')) {
    terminfoPath = '~/share/terminfo';
  } else {
    terminfoPath = '~/.terminfo';
  }

  for (const terminfo of resource.files('*.terminfo')) {
    await command('tic', ['-o', terminfoPath, terminfo]);
  }
});
