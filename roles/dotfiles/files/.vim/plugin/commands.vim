command! -nargs=* -complete=file OpenInDiffusion call wincent#commands#open_in_diffusion(<f-args>)
command! -nargs=* -complete=file Preview call wincent#commands#preview(<f-args>)
command! -nargs=* Search call wincent#commands#search(<q-args>)
