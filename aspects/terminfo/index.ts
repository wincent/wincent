import {command, file, path, task, variable} from '../../src/Fig';

task('create target directory', () => {
  file({
    path: variable.string('terminfo_path'),
    state: 'directory',
  });
});

task('update terminfo files', () => {
  for (const terminfo of path.files('*.terminfo')) {
    command('tic', '-o', variable.string('terminfo_path'), terminfo);
  }
});
