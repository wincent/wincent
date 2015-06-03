function! statusline#ft() abort
  if strlen(&ft)
    return ',' . &ft
  else
    return ''
  endif
endfunction

function! statusline#fenc() abort
  if strlen(&fenc) && &fenc !=# 'utf-8'
    return ',' . &fenc
  else
    return ''
  endif
endfunction

function! statusline#update_highlight() abort
  " Update User1 to use italics.
  let l:highlight = functions#italicize_group('StatusLine')
  execute 'highlight User1 ' . l:highlight

  " Make not-current window status lines visible against ColorColumn background.
  " Note that we can't use an exact copy of StatusLine here because in that case
  " Vim will helpfully(?) fill in the background with "^^^".
  highlight clear StatusLineNC
  highlight! link StatusLineNC User1
endfunction
