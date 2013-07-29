if exists('+relativenumber')
  " cycle through number, relativenumber and no numbering
  nnoremap <leader>r :set <c-r>={ '00': 'r', '01': 'no', '10': ''}[&rnu . &nu]<CR>nu<CR>
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

" delete all buffers, except for those with unsaved changes
nnoremap <leader>da :bufdo silent! bdelete<CR>

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
nnoremap <Space> <C-f>

" Insert mode mappings
inoremap jj <Esc>
inoremap jk <Esc>
inoremap kj <Esc>
