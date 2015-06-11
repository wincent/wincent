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
      call UltiSnips#JumpForwards()
      if g:ulti_jump_forwards_res == 0
        " We did not jump forwards.
        return "\<Tab>"
      endif
    endif
  endif

  " No popup is visible, a snippet was expanded, or we jumped, so nothing to do.
  return ''
endfunction
