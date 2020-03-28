import {task} from '../../src/Fig';

task('create target directory', ({file, variable}) => {
  file({
    path: variable.string('terminfo_path'),
    state: 'directory',
  });
});

task('update terminfo files', ({command, path, variable}) => {
  for (const file of path.files('*.terminfo')) {
    command('tic', '-o', variable.string('terminfo_path'), file);
  }
});
