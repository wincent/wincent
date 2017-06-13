" If UltiSnips' own "after" hook runs after us (and `:scriptnames` shows that it
" does), don't let it overwrite us.
let b:did_after_plugin_ultisnips_after=1

" Note: assuming here that `g:UltiSnipsExpandTrigger` and
" `g:UltiSnipsJumpForwardTrigger` are the same.
execute 'inoremap <silent> ' . g:UltiSnipsExpandTrigger .
      \ ' <C-R>=wincent#autocomplete#expand_or_jump("N")<CR>'
execute 'snoremap <silent> ' . g:UltiSnipsExpandTrigger .
      \ ' <Esc>:call wincent#autocomplete#expand_or_jump("N")<CR>'
execute 'inoremap <silent> ' . g:UltiSnipsJumpBackwardTrigger .
      \ ' <C-R>=wincent#autocomplete#expand_or_jump("P")<CR>'
execute 'snoremap <silent> ' . g:UltiSnipsJumpBackwardTrigger .
      \ ' <Esc>:call wincent#autocomplete#expand_or_jump("P")<CR>'
