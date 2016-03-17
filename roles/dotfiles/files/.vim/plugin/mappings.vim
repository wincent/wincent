" <LocalLeader>c -- Fix (most) syntax highlighting problems in current buffer
" (mnemonic: coloring).
nnoremap <silent> <LocalLeader>c :syntax sync fromstart<CR>

" <Leader>r -- Cycle through relativenumber + number, number (only), and no
" numbering (mnemonic: relative).
nnoremap <silent> <Leader>r :call mappings#cycle_numbering()<CR>

" <Leader><Leader> -- Open last buffer.
nnoremap <Leader><Leader> <C-^>

" <Leader>e -- Edit file, starting in same directory as current file.
nnoremap <Leader>e :edit <C-R>=expand('%:p:h') . '/'<CR>

" <leader>p -- Show the path of the current file (mnemonic: path; useful when
" you have a lot of splits and the status line gets truncated).
nnoremap <Leader>p :echo expand('%')<CR>

" <Leader>pp -- Like <Leader>p, but additionally yanks the filename and sends it
" off to Clipper.
nnoremap <Leader>pp :let @0=expand('%') <Bar> :Clip<CR> :echo expand('%')<CR>

nnoremap <Leader>o :only<CR>
nnoremap <Leader>q :quit<CR>
nnoremap <Leader>w :write<CR>
nnoremap <Leader>x :xit<CR>

" Toggle fold at current position.
" (Using s-tab to avoid collision between <tab> and <C-i>).
nnoremap <s-tab> za

" <Leader>zz -- Zap trailing whitespace in the current buffer.
"
"        As this one is somewhat destructive and relatively close to the
"        oft-used <leader>a mapping, make this one a double key-stroke.
nnoremap <silent> <Leader>zz :call mappings#zap()<CR>

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
