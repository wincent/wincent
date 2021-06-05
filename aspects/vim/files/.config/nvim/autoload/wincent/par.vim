function! wincent#par#filetype(filetype) abort
  let l:formatprg=len(&l:formatprg) ? &l:formatprg : &formatprg
  if match(l:formatprg, '^par ') == -1
    return
  endif

  let l:textwidth=len(&l:textwidth) ? &l:textwidth : &textwidth
  if l:textwidth == 0
    " `par` widths must be an 'unsigned decimal
    " integer less than 10000'
    let l:textwidth=9999
  endif
  if match(l:formatprg, 'w') == -1
    let l:adjusted=l:formatprg . 'w'. l:textwidth
  else
    let l:adjusted=substitute(l:formatprg, 'w\d\+', 'w' . l:textwidth, '')
  endif

  if len(&l:formatprg) && &l:formatprg != l:adjusted
    let &l:formatprg=l:adjusted
  elseif len(&formatprg) && &formatprg != l:adjusted
    let &formatprg=l:adjusted
  endif
endfunction
