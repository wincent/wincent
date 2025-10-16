function! s:Setf(filetype) abort
  if &filetype !~# '\<'.a:filetype.'\>'
    let &filetype = a:filetype
  endif
endfunction

function! s:StarSetf(ft) abort
  if expand("<amatch>") !~# get(g:, 'ft_ignore_pat', '0\&1')
    call s:Setf(a:filetype)
  endif
endfunction

" Git
au BufNewFile,BufRead COMMIT_EDITMSG,TAG_EDITMSG,MERGE_MSG	call s:Setf('gitcommit')
au BufNewFile,BufRead NOTES_EDITMSG,EDIT_DESCRIPTION		call s:Setf('gitcommit')
au BufNewFile,BufRead *.git/config,.gitconfig,*/etc/gitconfig	call s:Setf('gitconfig')
au BufNewFile,BufRead */.config/git/config			call s:Setf('gitconfig')
au BufNewFile,BufRead */.git/config.worktree			call s:Setf('gitconfig')
au BufNewFile,BufRead */.git/worktrees/*/config.worktree	call s:Setf('gitconfig')
au BufNewFile,BufRead .gitmodules,*.git/modules/*/config	call s:Setf('gitconfig')
if !empty($XDG_CONFIG_HOME)
  au BufNewFile,BufRead $XDG_CONFIG_HOME/git/config		call s:Setf('gitconfig')
endif
au BufNewFile,BufRead git-rebase-todo		call s:Setf('gitrebase')
au BufNewFile,BufRead .gitsendemail.msg.??????	call s:Setf('gitsendemail')
au BufNewFile,BufRead *.git/*
      \ if empty(&filetype) && getline(1) =~# '^\x\{40,\}\>\|^ref: ' |
      \   set ft=git |
      \ endif

au BufNewFile,BufRead */.gitconfig.d/*,/etc/gitconfig.d/*	call s:StarSetf('gitconfig')

au BufNewFile,BufRead *.patch
      \ if getline(1) =~# '^From [0-9a-f]\{40,\} Mon Sep 17 00:00:00 2001$' |
      \   call s:Setf('gitsendemail') |
      \ endif

" This logic really belongs in scripts.vim
au BufNewFile,BufRead,StdinReadPost *
      \ if empty(&filetype) && getline(1) =~# '^\(commit\|tree\|object\) \x\{40,\}\>\|^tag \S\+$' |
      \   set ft=git |
      \ endif
