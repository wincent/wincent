""
" @plugin vcs-jmp vcs-jump plug-in for Vim
"
" # Intro
"
" This plug-in allows you to jump to useful places within a Git or Mercurial
" repository.
"
if exists('g:VcsJumpLoaded') || &compatible || v:version < 700
  finish
endif
let g:VcsJumpLoaded = 1

" Temporarily set 'cpoptions' to Vim default as per `:h use-cpo-save`.
let s:cpoptions = &cpoptions
set cpoptions&vim

command! -nargs=+ -complete=file VcsJump call vcsjump#jump(<q-args>)

if !hasmapto('<Plug>(VcsJump)') && maparg('<Leader>d', 'n') ==# ''
  ""
  " @mappings <Plug>(VcsJump)
  "
  " This mapping invokes the bundled `vcs-jump` script.
  "
  nmap <unique> <Leader>d <Plug>(VcsJump)
endif

nnoremap <Plug>(VcsJump) :VcsJump diff<space>
