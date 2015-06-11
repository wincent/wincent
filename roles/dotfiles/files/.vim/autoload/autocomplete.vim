function! autocomplete#setup_mappings()
  " Overwrite the mappings that UltiSnips sets up during expansion.
  execute 'inoremap <buffer> <silent> ' . g:UltiSnipsJumpForwardTrigger .
        \ ' <C-R>=autocomplete#expand_or_jump("N")<cr>'
  execute 'snoremap <buffer> <silent> ' . g:UltiSnipsJumpForwardTrigger .
        \ ' <C-R>=autocomplete#expand_or_jump("N")<cr>'
  execute 'inoremap <buffer> <silent> ' . g:UltiSnipsJumpBackwardTrigger .
        \ ' <C-R>=autocomplete#expand_or_jump("P")<cr>'
  execute 'snoremap <buffer> <silent> ' . g:UltiSnipsJumpBackwardTrigger .
        \ ' <C-R>=autocomplete#expand_or_jump("P")<cr>'

  " One additional mapping of our own.
  " BUG: seems you have to do <CR> twice to actual finalize completion
  " (this happens even with the standard <C-Y>
  inoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<CR>"
  snoremap <expr> <CR> pumvisible() ? "\<C-Y>" : "\<CR>"
endfunction

function! autocomplete#teardown_mappings()
  silent iunmap <expr> <CR>
  silent sunmap <expr> <CR>
endfunction

let g:ulti_jump_backwards_res = 0
let g:ulti_jump_forwards_res = 0
let g:ulti_expand_res = 0

function! autocomplete#expand_or_jump(direction)
  call UltiSnips#ExpandSnippet()
  if g:ulti_expand_res == 0
    " No expansion occurred.
    if pumvisible()
      " Pop-up is visible, let's select the next (or previous) completion.
      if a:direction == 'N'
        return "\<C-N>"
      else
        return "\<C-P>"
      endif
    elseif a:direction == 'N'
      call UltiSnips#JumpForwards()
      if g:ulti_jump_forwards_res == 0
        " We did not jump forwards.
        return "\<Tab>"
      endif
    else
      call UltiSnips#JumpBackwards()
      if g:ulti_jump_backwards_res == 0
        " We did not jump backwards.
        " BUG: doesn't work, this always ends up being a forwards tab
        return "\<S-Tab>"
      endif
    endif
  endif

  " No popup is visible, a snippet was expanded, or we jumped, so nothing to do.
  return ''
endfunction
