" \c -- fix (most) syntax highlighting problems in current buffer
" (mnemonic: coloring)
nnoremap <silent> <leader>c :syntax sync fromstart<cr>

if exists('+relativenumber')
  " \r -- cycle through relativenumber + number, number (only), and no numbering
  nnoremap <leader>r :<c-r>={
        \ '00': 'set rnu   <bar> set nu',
        \ '01': 'set nornu <bar> set nu',
        \ '10': 'set nornu <bar> set nonu',
        \ '11': 'set nornu <bar> set nu' }[&nu . &rnu]<cr><cr><cr>
else
  " \r -- toggle line numbers on and off
  nnoremap <leader>r :set nu!<cr>
endif

" \\ -- open last buffer
nnoremap <leader><leader> <C-^>

" \e -- edit file, starting in same directory as current file
nnoremap <leader>e :edit <C-R>=expand('%:p:h') . '/'<CR>

" \p -- show the path of the current file
" (useful when you have a lot of splits and the status line gets truncated)
nnoremap <leader>p :echo expand('%')<CR>

" \pp -- like \p, but additionally yanks the filename and sends it off to Clipper
nnoremap <leader>pp :let @0=expand('%') <Bar> :Clip<CR> :echo expand('%')<CR>

" \zz -- Zap trailing whitespace in the current buffer.
"
"        As this one is somewhat destructive and relatively close to the
"        oft-used <leader>a mapping, make this one a double key-stroke.
nnoremap <silent> <leader>zz :let _last_search=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_last_search <Bar> :nohlsearch<CR>

" \n -- no search highlighting
nnoremap <silent> <leader>n :nohlsearch<CR>:call mappings#clear_highlight()<CR>

" Make Vim's regexen more Perl-like.
nnoremap <expr> / mappings#prepare_highlight('/\v')
nnoremap <expr> ? mappings#prepare_highlight('?\v')
xnoremap <expr> / mappings#prepare_highlight('/\v')
xnoremap <expr> ? mappings#prepare_highlight('?\v')
cnoremap <expr> / mappings#very_magic_slash()

" Remain centered when moving to next/previous search.
" Make current search match more obvious.
nnoremap <silent> # #zz:call mappings#hlmatch()<CR>
nnoremap <silent> * *zz:call mappings#hlmatch()<CR>
nnoremap <silent> N Nzz:call mappings#hlmatch()<CR>
nnoremap <silent> g# g#zz:call mappings#hlmatch()<CR>
nnoremap <silent> g* g*zz:call mappings#hlmatch()<CR>
nnoremap <silent> n nzz:call mappings#hlmatch()<CR>

" \zc -- a macro I recorded to rebalance/resort the columns in the Command-T
"        "authors" section; requires that the author names be visually selected:
xnoremap <leader>zc
  \:s/\v^ +//g<CR>
  \gv:s/\v  +/\r/g<CR>
  \gvj:sort<CR>
  \V}k:!column -c 78<CR>
  \:let _tabstop=&tabstop<CR>
  \:set tabstop=8<CR>
  \V}:retab<CR>
  \:let &tabstop=_tabstop<CR>
  \gv>:nohlsearch<CR>

" multi-mode mappings (Normal, Visual, Operating-pending modes)
noremap Y y$

" Command mode mappings
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

" Normal mode mappings
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-kPlus> <C-w>+
nnoremap <C-kMinus> <C-w>-
nnoremap <Space> za

" for each time K has produced timely, useful results, I have pressed it 10,000
" times without meaning to, triggering an annoying delay
nnoremap K <nop>
