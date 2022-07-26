" Normal mode mappings.

" Toggle fold at current position.
nnoremap <Tab> za

" Relying on Karabiner-Elements (macOS) or Interception Tools (Linux) to avoid
" collision between <Tab> and <C-i> (have it send F6 instead for <C-i>).
nnoremap <F6> <C-i>

" Avoid unintentional switches to Ex mode.
nnoremap Q <nop>

" Multi-mode mappings (Normal, Visual, Operating-pending modes).
noremap Y y$

nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Repurpose cursor keys (accessible near homerow via "SpaceFN" layout) for one
" of my most oft-use key sequences.
nnoremap <silent> <Up> :cprevious<CR>
nnoremap <silent> <Down> :cnext<CR>
nnoremap <silent> <Left> :cpfile<CR>
nnoremap <silent> <Right> :cnfile<CR>
