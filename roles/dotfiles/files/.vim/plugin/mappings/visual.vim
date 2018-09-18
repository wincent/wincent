" Visual mode mappings.

" Move between windows.
xnoremap <C-h> <C-w>h
xnoremap <C-j> <C-w>j
xnoremap <C-k> <C-w>k
xnoremap <C-l> <C-w>l

" Move VISUAL LINE selection within buffer.
xnoremap <silent> K :call wincent#mappings#visual#move_up()<CR>
xnoremap <silent> J :call wincent#mappings#visual#move_down()<CR>
