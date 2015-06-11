let s:expansion_active = 0

function! autocomplete#setup_mappings()
  " Overwrite the mappings that UltiSnips sets up during expansion.
  execute 'inoremap <buffer> <silent> ' . g:UltiSnipsJumpForwardTrigger .
        \ ' <C-R>=autocomplete#expand_or_jump("N")<cr>'
  execute 'snoremap <buffer> <silent> ' . g:UltiSnipsJumpForwardTrigger .
        \ ' <Esc>:call autocomplete#expand_or_jump("N")<cr>'
  execute 'inoremap <buffer> <silent> ' . g:UltiSnipsJumpBackwardTrigger .
        \ ' <C-R>=autocomplete#expand_or_jump("P")<cr>'
  execute 'snoremap <buffer> <silent> ' . g:UltiSnipsJumpBackwardTrigger .
        \ ' <Esc>:call autocomplete#expand_or_jump("P")<cr>'

  " One additional mapping of our own.
  " BUG: seems you have to do <CR> twice to actual finalize completion
  " (this happens even with the standard <C-Y>
  inoremap <expr> <buffer> <silent> <CR> pumvisible() ? "\<C-Y>" : "\<CR>"
  snoremap <expr> <buffer> <silent> <CR> pumvisible() ? "\<C-Y>" : "\<CR>"

  let s:expansion_active = 1
endfunction

function! autocomplete#teardown_mappings()
  silent! iunmap <expr> <buffer> <cr>
  silent! sunmap <expr> <buffer> <CR>

  let s:expansion_active = 0
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
    else
      if s:expansion_active
        if a:direction == 'N'
          call UltiSnips#JumpForwards()
          if g:ulti_jump_forwards_res == 0
            " We did not jump forwards.
            return "\<Tab>"
          endif
        else
          call UltiSnips#JumpBackwards()
        endif
      else
        if a:direction == 'N'
          return "\<Tab>"
        endif
      endif
    endif
  endif

  " No popup is visible, a snippet was expanded, or we jumped, or we failed to
  " jump backwards, so nothing to do.
  return ''
endfunction
