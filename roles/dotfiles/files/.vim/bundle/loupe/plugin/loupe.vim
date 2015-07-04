" \n -- no search highlighting
nnoremap <silent> <leader>n :nohlsearch<CR>:call loupe#clear_highlight()<CR>

" Make Vim's regexen more Perl-like.
nnoremap <expr> / loupe#prepare_highlight('/\v')
nnoremap <expr> ? loupe#prepare_highlight('?\v')
xnoremap <expr> / loupe#prepare_highlight('/\v')
xnoremap <expr> ? loupe#prepare_highlight('?\v')
cnoremap <expr> / loupe#very_magic_slash()

" Remain centered when moving to next/previous search.
" Make current search match more obvious.
nnoremap <silent> # #zz:call loupe#hlmatch()<CR>
nnoremap <silent> * *zz:call loupe#hlmatch()<CR>
nnoremap <silent> N Nzz:call loupe#hlmatch()<CR>
nnoremap <silent> g# g#zz:call loupe#hlmatch()<CR>
nnoremap <silent> g* g*zz:call loupe#hlmatch()<CR>
nnoremap <silent> n nzz:call loupe#hlmatch()<CR>
