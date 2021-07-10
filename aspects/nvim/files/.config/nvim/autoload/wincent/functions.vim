" Turn on spell-checking.
function! wincent#functions#spell() abort
  setlocal spell
  setlocal spellfile=~/.config/nvim/spell/en.utf-8.add
  setlocal spelllang=en,es
endfunction

" Switch to plaintext mode with: call wincent#functions#plaintext()
function! wincent#functions#plaintext() abort
  setlocal concealcursor=nc
  setlocal nolist
  setlocal textwidth=0
  setlocal wrap
  setlocal wrapmargin=0

  call wincent#functions#spell()

  " Break undo sequences into chunks (after punctuation); see: `:h i_CTRL-G_u`
  "
  " From:
  "
  "   https://twitter.com/vimgifs/status/913390282242232320
  "
  " Via:
  "
  "   https://github.com/ahmedelgabri/dotfiles/blob/f2b74f6cd4d/files/.vim/plugin/mappings.vim#L27-L33
  "
  inoremap <buffer> ! !<C-g>u
  inoremap <buffer> , ,<C-g>u
  inoremap <buffer> . .<C-g>u
  inoremap <buffer> : :<C-g>u
  inoremap <buffer> ; ;<C-g>u
  inoremap <buffer> ? ?<C-g>u

  nnoremap <buffer> j gj
  nnoremap <buffer> k gk

  " Ideally would keep 'list' set, and restrict 'listchars' to just show
  " whitespace errors, but 'listchars' is global and I don't want to go through
  " the hassle of saving and restoring.
  autocmd BufWinEnter <buffer> match Error /\s\+$/
  autocmd InsertEnter <buffer> match Error /\s\+\%#\@<!$/
  autocmd InsertLeave <buffer> match Error /\s\+$/
  autocmd BufWinLeave <buffer> call clearmatches()
endfunction

let g:html_font=['Source Code Pro', 'Consolas', 'Monaco']

" Open a syntax-colored version of the current file
" suitable for copy-pasting into a presentation.
function! wincent#functions#keynote() abort
  setlocal nonumber
  setlocal norelativenumber
  TOhtml
  let l:tempfile=trim(system('mktemp')) . '.html'
  echomsg l:tempfile
  execute 'saveas! ' . l:tempfile
  execute '!open -b com.google.Chrome ' . l:tempfile
  quit
endfunction

function! wincent#functions#substitute(pattern, replacement, flags) abort
  let l:number=1
  for l:line in getline(1, '$')
    call setline(l:number, substitute(l:line, a:pattern, a:replacement, a:flags))
    let l:number=l:number + 1
  endfor
endfunction

" Sort a .gitmodules file.
"
" See also: https://wincent.com/wiki/Sorting_.gitmodules_entries_with_Vim
function! wincent#functions#sortgitmodules(...) abort
  if &ft ==# 'gitconfig' || a:0
    silent %s/\v\n\t/@@@/e
    %sort
    silent %s/\v\@\@\@/\r\t/ge
  else
    echomsg 'Not a "gitconfig" file: use `wincent#functions#sortgitmodules(1)` to force'
  endif
endfunction

" http://stackoverflow.com/a/39348498/2103996
function! wincent#functions#clearregisters() abort
  let l:regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
  for l:reg in l:regs
    call setreg(l:reg, [])
  endfor
endfunction

" Like :echoerr, but without the stack trace.
function! wincent#functions#echoerr(msg) abort
  try
    echohl ErrorMsg
    echomsg a:msg
  finally
    echohl None
  endtry
endfunction
