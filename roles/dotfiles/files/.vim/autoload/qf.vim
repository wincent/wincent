" Remove lines a:first through a:last from the quickfix listing.
function! s:delete(first, last)
  let l:list = getqflist()
  let l:line = a:first

  while l:line >= a:first && l:line <= a:last
    " Non-dictionary items will be ignored. This effectively deletes the line.
    let l:list[l:line - 1] = 0
    let l:line = l:line + 1
  endwhile
  call setqflist(l:list, 'r')

  " Show to next entry.
  execute 'cc ' . a:first

  " Move focus back to quickfix listing.
  execute "normal \<C-W>\<C-P>"
endfunction

" Visual mode deletion and `dd` mapping (special case).
function! qf#delete() range
  call s:delete(a:firstline, a:lastline)
endfunction

" Motion-based deletion from quickfix listing.
function! qf#delete_motion(type, ...)
  " Save.
  let l:selection = &selection
  let &selection = 'inclusive'

  let l:firstline = line("'[")
  let l:lastline = line("']")
  call s:delete(l:firstline, l:lastline)

  " Restore.
  let &selection = l:selection
endfunction
