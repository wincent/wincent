" Copyright 2015-present Greg Hurrell. All rights reserved.
" Licensed under the terms of the BSD 2-clause license.

" Provide users with means to prevent loading, as recommended in `:h
" write-plugin`.
if exists('g:LoupeLoaded') || &compatible || v:version < 700
  finish
endif
let g:LoupeLoaded = 1

" Temporarily set 'cpoptions' to Vim default as per `:h use-cpo-save`.
let s:cpoptions = &cpoptions
set cpoptions&vim

" Reasonable defaults for search-related settings.
if &history < 1000
  set history=1000 " Longer search and command history (default is 50).
endif
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
    nmap <silent> <unique> <leader>n <Plug>LoupeClearHighlight
  endif
endif
nnoremap <silent> <Plug>LoupeClearHighlight
      \ :nohlsearch<CR>
      \ :call loupe#private#clear_highlight()<CR>

" Make `:nohlsearch` behave like <Plug>LoupeClearHighlight.
let s:abbrev = 'nohlsearch'
while len(s:abbrev) >= 3
  " For each abbrev, execute a command like:
  "   cabbrev <silent> <expr> nohl (getcmdtype() == ':' && getcmdpos() == 5 ? 'nohl <bar> call loupe#private#clear_highlight()<CR>' : 'nohl')
  execute
        \ 'cabbrev <silent> <expr> ' .
        \ s:abbrev .
        \ " (getcmdtype() == ':' && getcmdpos() == " . (len(s:abbrev) + 1)  .
        \ " ? '" . s:abbrev . ' <bar> ' .
        \ "call loupe#private#clear_highlight()<CR>' : '" .s:abbrev "')"

  " Trim off final character of abbreviation.
  let s:abbrev = s:abbrev[0:len(s:abbrev) - 2]
endwhile

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
