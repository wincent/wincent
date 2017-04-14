set columns=132       " default GUI window width (80) is too narrow
set lines=999         " create windows with maximum height by default

if has('gui_macvim')
  set fuopt+=maxhorz  " maximum horizontal width on entering fullscreen mode
endif

if exists('&macthinstrokes')
  set macthinstrokes
endif
