nnoremap <silent> <leader>u :GundoToggle<CR>

" The diff preview tends to be tiny and unreadable; give it more space.
let g:gundo_preview_bottom=1

" The default (45) is generally too wide; making it narrower helps when on a
" small Vim instance (eg. half of a tmux split on the internal laptop display).
let g:gundo_width=30

" When you revert to a revision (ie. with <CR>), close the Gundo windows.
let g:gundo_close_on_revert=1
