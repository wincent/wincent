- solarized

  For convenience, the official Solarized repo, containing the iTerm 2 color
  files.

- .terminfo

  Not linked by default as it is not needed on all machines I work on.

  Specifically, I mostly work using iTerm2 (on Mac OS X) and have it set to
  report itself as "xterm-256color" (often inside a tmux session, where the TERM
  type should be "screen-256color").

  Mac OS X has terminfo files for both those terminal types, as does the default
  Amazon Linux AMI. On some older CentOS machines that I work on, however, there
  is only "xterm-256color" and "screen"; on those if I want Vim to work properly
  inside of tmux I have to link the supplied terminfo file into place, or run
  using "xterm-256color" (which works but is not ideal; for example, on-the-fly
  switching between dark and light backgrounds doesn't work properly).
