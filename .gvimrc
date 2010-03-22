set columns=132   " default GUI window width (80) is too narrow
set lines=999     " create windows with maximum height by default

if has("gui_macvim")
  set noanti                              " no antialiasing
  set fuopt+=maxhorz                      " grow to maximum horizontal width on entering fullscreen mode

  " free up Command T
  macmenu &File.Open\ Tab\.\.\. key=<nop>
  macmenu &File.New\ Tab key=<nop>
  map <D-t> :CommandT<CR>

  " free up Command O
  macmenu &File.Open\.\.\. key=<nop>
  imap <D-o> <C-o>o
  imap <D-O> <C-o>O

  " free up Command-A
  macmenu &Edit.Select\ All key=<nop>
  imap <D-a> <C-o>A
  imap <D-i> <C-o>I
  imap <D-0> <C-o>gI

  " normal mode mappings
  nnoremap <silent> <D-j> :call SwapWithNext()<CR>
  nnoremap <silent> <D-k> :call SwapWithPrevious()<CR>
endif
