// because we want relative file access, will have to direct it via API (because
// files are in "aspects" but we are built in "lib/aspects"

// - name: terminfo | create target directory
//   file: path={{ terminfo_path }} state=directory
Fig.task('create target directory');

// - name: terminfo | update terminfo files
//   command:
//     tic -o {{ terminfo_path }} roles/terminfo/files/{{ item }}
//   loop:
//     - tmux.terminfo
//     - tmux-256color.terminfo
//     - xterm-256color.terminfo
