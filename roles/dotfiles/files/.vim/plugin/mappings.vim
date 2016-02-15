" <leader>c -- Fix (most) syntax highlighting problems in current buffer
" (mnemonic: coloring).
nnoremap <silent> <leader>c :syntax sync fromstart<CR>

if exists('+relativenumber')
  " <leader>r -- Cycle through relativenumber + number, number (only), and no
  " numbering (mnemonic: relative).
  nnoremap <leader>r :<c-r>={
        \ '00': 'set rnu   <bar> set nu',
        \ '01': 'set nornu <bar> set nu',
        \ '10': 'set nornu <bar> set nonu',
        \ '11': 'set nornu <bar> set nu' }[&nu . &rnu]<CR><CR><CR>
else
  " <leader>r -- Toggle line numbers on and off (mnemonic: relative).
  nnoremap <leader>r :set nu!<CR>
endif

" <leader><leader> -- Open last buffer.
nnoremap <leader><leader> <C-^>

" <leader>e -- Edit file, starting in same directory as current file.
nnoremap <leader>e :edit <C-R>=expand('%:p:h') . '/'<CR>

" <leader>p -- Show the path of the current file (mnemonic: path; useful when
" you have a lot of splits and the status line gets truncated).
nnoremap <leader>p :echo expand('%')<CR>

" <leader>pp -- Like <leader>p, but additionally yanks the filename and sends it
" off to Clipper.
nnoremap <leader>pp :let @0=expand('%') <Bar> :Clip<CR> :echo expand('%')<CR>

nnoremap <leader>h :help<space>
nnoremap <leader>o :only<CR>
nnoremap <leader>q :quit<CR>
nnoremap <leader>w :write<CR>
nnoremap <leader>x :xit<CR>

" <leader>zz -- Zap trailing whitespace in the current buffer.
"
"        As this one is somewhat destructive and relatively close to the
"        oft-used <leader>a mapping, make this one a double key-stroke.
nnoremap <silent> <leader>zz :let _last_search=@/ <Bar> :%s/\s\+$//e <Bar> :let @/=_last_search <Bar> :nohlsearch<CR>

" Multi-mode mappings (Normal, Visual, Operating-pending modes).
noremap Y y$

" Command mode mappings.
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

" Normal mode mappings.
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-kPlus> <C-w>+
nnoremap <C-kMinus> <C-w>-

" Like vim-vinegar.
nnoremap <silent> - :silent edit <C-R>=empty(expand('%')) ? '.' : expand('%:p:h')<CR><CR>

" Visual mode mappings.
xnoremap <C-h> <C-w>h
xnoremap <C-j> <C-w>j
xnoremap <C-k> <C-w>k
xnoremap <C-l> <C-w>l

" For each time K has produced timely, useful results, I have pressed it 10,000
" times without meaning to, triggering an annoying delay.
nnoremap K <nop>

" Repurpose cursor keys (accessible near homerow via "SpaceFN" layout) for one
" of my most oft-use key sequences.
nnoremap <silent> <Up> :cprevious<CR>
nnoremap <silent> <Down> :cnext<CR>
nnoremap <silent> <Left> :cpfile<CR>
nnoremap <silent> <Right> :cnfile<CR>
