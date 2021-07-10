augroup WincentDirvish
  autocmd!
  " Overwrite default mapping for the benefit of my muscle memory.
  " ('o' would normally open in a split window, but we want it to open in the
  " current one.)
  autocmd FileType dirvish
        \ silent! nnoremap <nowait><buffer><silent> o :<C-U>.call dirvish#open('edit', 0)<CR>

  " Seeing as wincent.colorcolumn_filetype_blacklist doesn't work for this:
  autocmd FileType dirvish setlocal colorcolumn=
augroup END
