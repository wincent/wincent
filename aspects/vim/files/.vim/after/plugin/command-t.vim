"
" Settings.
"

let g:CommandTCancelMap=['<ESC>', '<C-c>']

if &term =~# 'screen' || &term =~# 'tmux' || &term =~# 'xterm'
  let g:CommandTSelectNextMap = ['<C-j>', '<Down>', '<ESC>OB']
  let g:CommandTSelectPrevMap = ['<C-k>', '<Up>', '<ESC>OA']
endif

let g:CommandTEncoding='UTF-8'
let g:CommandTFileScanner='watchman'
let g:CommandTInputDebounce=50
let g:CommandTMaxCachedDirectories=10
let g:CommandTMaxFiles=3000000
let g:CommandTScanDotDirectories=1
let g:CommandTTraverseSCM='pwd'
let g:CommandTWildIgnore=&wildignore
let g:CommandTWildIgnore.=',*/.git/*'
let g:CommandTWildIgnore.=',*/.hg/*'
let g:CommandTWildIgnore.=',*/bower_components/*'
let g:CommandTWildIgnore.=',*/tmp/*'
let g:CommandTWildIgnore.=',*.class'
let g:CommandTWildIgnore.=',*/classes/*'
let g:CommandTWildIgnore.=',*/build/*'

" Allow Command-T to open selections in dirvish windows.
let g:CommandTWindowFilter='!&buflisted && &buftype == "nofile" && &filetype !=# "dirvish"'

"
" Mappings.
"

nmap <unique> <LocalLeader>c <Plug>(CommandTCommand)
nmap <unique> <Leader>h <Plug>(CommandTHelp)
nmap <unique> <LocalLeader>h <Plug>(CommandTHistory)
nmap <unique> <LocalLeader>l <Plug>(CommandTLine)
nmap <unique> <LocalLeader>t <Plug>(CommandTTag)

" Convenience for starting Command-T at launch without causing freak-out inside
" tmux.

function s:CommandTPreBoot()
  augroup CommandTBoot
    autocmd!
    autocmd VimEnter * call s:CommandTPostBoot()
  augroup END
endfunction

function s:CommandTPostBoot()
  augroup CommandTBoot
    autocmd!
  augroup END
  CommandT
endfunction

command CommandTBoot call s:CommandTPreBoot()
