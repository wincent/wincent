"
" Settings.
"

if &term =~# 'screen' || &term =~# 'tmux' || &term =~# 'xterm'
  let g:CommandTCancelMap=['<ESC>', '<C-c>']
  let g:CommandTSelectNextMap = ['<C-n>', '<C-j>', '<Down>', '<ESC>OB']
  let g:CommandTSelectPrevMap = ['<C-p>', '<C-k>', '<Up>', '<ESC>OA']
endif

let g:CommandTEncoding='UTF-8'
let g:CommandTFileScanner='watchman'
let g:CommandTMaxCachedDirectories=10
let g:CommandTMaxFiles=2000000
let g:CommandTScanDotDirectories=1
let g:CommandTTraverseSCM='pwd'
let g:CommandTWildIgnore=&wildignore
let g:CommandTWildIgnore.=',*/.git'
let g:CommandTWildIgnore.=',*/.hg'
let g:CommandTWildIgnore.=',*/bower_components'
let g:CommandTWildIgnore.=',*/tmp'
let g:CommandTWildIgnore.=',*/vendor'

" Allow Command-T to open selections in netrw windows.
let g:CommandTWindowFilter='!&buflisted && &buftype == "nofile" && !exists("w:netrw_liststyle")'

"
" Mappings.
"

nmap <unique> <Leader>c <Plug>(CommandTCommand)
nmap <unique> <Leader>h <Plug>(CommandTHelp)
nmap <unique> <LocalLeader>h <Plug>(CommandTHistory)
nmap <unique> <LocalLeader>l <Plug>(CommandTLine)
nmap <unique> <LocalLeader>t <Plug>(CommandTTag)

let s:path = expand('<sfile>:p:h') . '/command-t.private.vim'
if filereadable(s:path)
  execute 'source ' . s:path
endif
