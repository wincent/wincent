command! -nargs=* -complete=file OpenInDiffusion call commands#open_in_diffusion(<f-args>)
command! -nargs=* -complete=file Preview call commands#preview(<f-args>)
command! -nargs=* Search call commands#search(<q-args>)
