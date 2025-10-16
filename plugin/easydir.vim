" Plugin:      easydir.vim
" Description: A simple plugin to create, edit and save files and directories.
" Version:     1.2
" Last Change: 2019 Dec 22
" Maintainer:  Doug Yun | <doug.yun@dockyard.com>
"              DockYard, LLC 2013 | http://dockyard.com
" License:     MIT License (MIT) | Copyright 2013

if exists('loaded_easydir')
  finish
endif
let loaded_easydir = 1

augroup easydir
  au!
  au BufWritePre,FileWritePre * call <SID>create_and_save_directory()
augroup END

function <SID>create_and_save_directory()
  let l:directory = expand('<afile>:p:h')
  if l:directory !~# '^\w\+:' && !isdirectory(l:directory)
    call mkdir(l:directory, 'p')
  endif
endfunction
