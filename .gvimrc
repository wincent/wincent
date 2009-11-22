set columns=132   " default GUI window width (80) is too narrow
set lines=999     " create windows with maximum height by default

if has("gui_macvim")
  set noanti                              " no antialiasing
  set fuopt+=maxhorz                      " grow to maximum horizontal width on entering fullscreen mode

  macmenu &File.Open\ Tab\.\.\. key=<nop> " free up Command-T
  macmenu &File.New\ Tab key=<D-T>        " 'New Tab' is now Shift-Command-T
  map <D-t> :FuzzyFinderFile<CR>

  macmenu &File.Open\.\.\. key=<nop>      " free up Command-O
  imap <D-o> <C-o>o
  imap <D-O> <C-o>O

  macmenu &Edit.Select\ All key=<nop>     " free up Command-A
  imap <D-a> <C-o>A
  imap <D-i> <C-o>I
  imap <D-0> <C-o>gI
endif
