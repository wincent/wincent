function! statusline#ft()
  if strlen(&ft)
    return ',' . &ft
  else
    return ''
  endif
endfunction

function! statusline#fenc()
  if strlen(&fenc) && &fenc !=# 'utf-8'
    return ',' . &fenc
  else
    return ''
  endif
endfunction

function statusline#update_user1()
  let l:highlight = functions#italicize_group('StatusLine')
  execute 'highlight User1 ' . l:highlight
endfunction
