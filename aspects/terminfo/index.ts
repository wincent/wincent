import {task} from '../../src/Fig';

task('create target directory', ({file, variable}) => {
  file({
    path: variable('terminfo_path'),
    state: 'directory'
  });
});

task('update terminfo files', ({command, path, variable}) => {
  [
    'tmux.terminfo',
    'tmux-256color.terminfo',
    'xterm-256color.terminfo',
  ].forEach(item => {
    command('tic', '-o', variable('terminfo_path'), path.file(item))
  });
});
