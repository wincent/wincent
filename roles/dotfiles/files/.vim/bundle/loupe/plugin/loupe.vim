" Copyright 2015-present Greg Hurrell. All rights reserved.
" Licensed under the terms of the BSD 2-clause license.

" Provide users with means to prevent loading, as recommended in `:h
" write-plugin`.
if exists('g:loupe_loaded') || &compatible || v:version < 700
  finish
endif
let g:loupe_loaded = 1

" Temporarily set 'cpoptions' to Vim default as per `:h use-cpo-save`.
let s:cpoptions = &cpoptions
set cpoptions&vim

" Reasonable defaults for search-related settings.
set history=1000 " Longer search and command history (default is 50).
if has('extra_search')
  set hlsearch   " Highlight search strings.
  set incsearch  " Incremental search ("find as you type").
endif
set ignorecase   " Ignore case when searching.
set shortmess+=s " Don't echo search wrap messages.
set smartcase    " Case-sensitive search if search string includes a capital letter.

" Map <leader>n to clear search highlighting.
let s:map = exists('g:LoupeClearHighlightMap') ? g:LoupeClearHighlightMap : 1
if s:map
  if !hasmapto('<Plug>LoupeClearHighlight') && maparg('<leader>n', 'n') ==# ''
    silent! nmap <silent> <unique> <leader>n <Plug>LoupeClearHighlight
  endif
endif
nnoremap <silent> <Plug>LoupeClearHighlight
      \ :nohlsearch<CR>
      \ :call loupe#private#clear_highlight()<CR>

" Make `:nohlsearch` behave like <Plug>LoupeClearHighlight.
cabbrev <silent> <expr> noh (getcmdtype() == ':' && getcmdpos() == 4 ? 'noh <bar> call loupe#private#clear_highlight()<CR>' : 'noh')
cabbrev <silent> <expr> nohl (getcmdtype() == ':' && getcmdpos() == 5 ? 'nohl <bar> call loupe#private#clear_highlight()<CR>' : 'nohl')
cabbrev <silent> <expr> nohls (getcmdtype() == ':' && getcmdpos() == 6 ? 'nohls <bar> call loupe#private#clear_highlight()<CR>' : 'nohls')
cabbrev <silent> <expr> nohlse (getcmdtype() == ':' && getcmdpos() == 7 ? 'nohlse <bar> call loupe#private#clear_highlight()<CR>' : 'nohlse')
cabbrev <silent> <expr> nohlsea (getcmdtype() == ':' && getcmdpos() == 8 ? 'nohlsea <bar> call loupe#private#clear_highlight()<CR>' : 'nohlsea')
cabbrev <silent> <expr> nohlsear (getcmdtype() == ':' && getcmdpos() == 9 ? 'nohlsear <bar> call loupe#private#clear_highlight()<CR>' : 'nohlsear')
cabbrev <silent> <expr> nohlsearc (getcmdtype() == ':' && getcmdpos() == 10 ? 'nohlsearc <bar> call loupe#private#clear_highlight()<CR>' : 'nohlsearc')
cabbrev <silent> <expr> nohlsearch (getcmdtype() == ':' && getcmdpos() == 11 ? 'nohlsearch <bar> call loupe#private#clear_highlight()<CR>' : 'nohlsearch')

" When g:LoupeVeryMagic is true (and it is by default), make Vim's regexen more
" Perl-like.
function s:MagicString()
  let s:magic = exists('g:LoupeVeryMagic') ? g:LoupeVeryMagic : 1
  return s:magic ? '\v' : ''
endfunction

nnoremap <expr> / loupe#private#prepare_highlight('/' . <SID>MagicString())
nnoremap <expr> ? loupe#private#prepare_highlight('?' . <SID>MagicString())
xnoremap <expr> / loupe#private#prepare_highlight('/' . <SID>MagicString())
xnoremap <expr> ? loupe#private#prepare_highlight('?' . <SID>MagicString())
if !empty(s:MagicString())
  cnoremap <expr> / loupe#private#very_magic_slash()
endif

" When g:LoupeCenterResults is true (and it is by default), remain vertically
" centered when moving to next/previous search.
let s:center = exists('g:LoupeCenterResults') ? g:LoupeCenterResults : 1
let s:center_string = s:center ? 'zz' : ''

execute 'nnoremap <silent> # #' . s:center_string . ':call loupe#private#hlmatch()<CR>'
execute 'nnoremap <silent> * *' . s:center_string . ':call loupe#private#hlmatch()<CR>'
execute 'nnoremap <silent> N N' . s:center_string . ':call loupe#private#hlmatch()<CR>'
execute 'nnoremap <silent> g# g#' . s:center_string . ':call loupe#private#hlmatch()<CR>'
execute 'nnoremap <silent> g* g*' . s:center_string . ':call loupe#private#hlmatch()<CR>'
execute 'nnoremap <silent> n n' . s:center_string . ':call loupe#private#hlmatch()<CR>'

" Clean-up stray `matchadd()` vestiges.
if has('autocmd') && has('extra_search')
  augroup LoupeCleanUp
    autocmd!
    autocmd WinEnter * :call loupe#private#cleanup()
  augroup END
endif

" Restore 'cpoptions' to its former value.
let &cpoptions = s:cpoptions
unlet s:cpoptions
