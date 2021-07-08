" TODO: complete `find` arg names too
" TODO: check escaping is correct
command! -nargs=* -complete=file Find call wincent#commands#find(<q-args>)

command! -nargs=* -complete=file -range OpenOnGitHub <line1>,<line2>call wincent#commands#open_on_github(<f-args>)

command! Lint call wincent#commands#lint()

command! Typecheck call wincent#commands#typecheck()

command! Vim call wincent#commands#vim()

" Markdown previews.
command! -nargs=? -complete=file Glow call wincent#commands#glow(<f-args>)
command! -nargs=* -complete=file Marked call wincent#commands#marked(<f-args>)
command! -nargs=* -complete=file Preview call wincent#commands#preview(<f-args>)
