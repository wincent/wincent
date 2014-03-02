nnoremap <silent> <leader>u :GundoToggle<CR>

" this is for the benefit of my sandbox, where I couldn't get Python 2.x to work
" it seems not to interfere with my local setup on OS X
let g:gundo_prefer_python3=1

" the diff preview tends to be tiny and unreadable; give it more space
let g:gundo_preview_bottom=1

" the default (45) is generally too wide; making it narrower helps when on a
" small Vim instance (eg. half of a tmux split on the internal laptop display)
let g:gundo_width=30

" when you revert to a revision (ie. with <CR>), close the Gundo windows
let g:gundo_close_on_revert=1
