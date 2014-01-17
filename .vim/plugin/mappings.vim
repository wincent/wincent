if exists('+relativenumber')
  " cycle through relativenumber + number, number (only), and no numbering
  nnoremap <leader>r :<c-r>={
        \ '00': 'set rnu   <bar> set nu',
        \ '01': 'set nornu <bar> set nu',
        \ '10': 'set nornu <bar> set nonu',
        \ '11': 'set nornu <bar> set nu' }[&nu . &rnu]<cr><cr>
else
  " toggle line numbers on and off
  nnoremap <leader>r :set nu!<cr>
endif

" open last buffer
nnoremap <leader><leader> <C-^>

" \e -- edit file, starting in same directory as current file
nnoremap <leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" \zz -- Zap trailing whitespace in the current buffer.
"
"        As this one is somewhat destructive and relatively close to the
"        oft-used <leader>a mapping, make this one a double key-stroke.
"
nnoremap <silent> <leader>zz :let _last_search=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_last_search <Bar> :noh<CR>

nnoremap <leader>n :set nocursorcolumn <Bar> noh <Bar> echo<CR>

" make Vim's regexen more Perl-like
" turn on cursorcolumn only temporarily here; it's a big performance hit, but
" really useful for disambiguating the current match
if exists('+cursorcolumn')
  nnoremap / :silent! set cursorcolumn<CR>/\v
else
  nnoremap / /\v
endif

vnoremap / /\v

" a macro I recorded to rebalance/resort the columns in the Command-T "authors"
" section; requires that the author names be visually selected:
vnoremap <leader>zc 
  \:s/\v^ +//g<CR>
  \gv:s/\v  +/\r/g<CR>
  \gvj:sort<CR>
  \V}k:!column -c 78<CR>
  \:let _tabstop=&tabstop<CR>
  \:set tabstop=8<CR>
  \V}:retab<CR>
  \:let &tabstop=_tabstop<CR>
  \gv>:noh<CR>

" delete all buffers, except for those with unsaved changes
nnoremap <leader>da :bufdo silent! bdelete<CR>

" Ruby 1.8 Hashes to 1.9
nnoremap <leader>h :%s/\v(:)@<!:([a-zA-Z_][a-zA-Z_0-9]*)(\s*)\=\>\s?/\2:\3/gce<cr>

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

" Insert mode mappings
inoremap jj <Esc>
