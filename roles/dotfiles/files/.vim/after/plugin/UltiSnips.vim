" If UltiSnips' own "after" hook runs after us, don't let it overwrite us.
let did_UltiSnips_after=1

inoremap <silent> <Tab> <C-R>=autocomplete#expand_or_jump("N")<CR>
inoremap <silent> <S-Tab> <C-R>=autocomplete#expand_or_jump("P")<CR>
