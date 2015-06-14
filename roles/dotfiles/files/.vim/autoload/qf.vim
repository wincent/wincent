" TODO: handle motions
function! qf#delete() range
  let l:line = a:firstline
  let l:list = getqflist()

  while l:line >= a:firstline && l:line <= a:lastline
    " Non-dictionary items will be ignored. This effectively deletes the line.
    let l:list[l:line - 1] = 0
    let l:line = l:line + 1
  endwhile
  call setqflist(l:list, 'r')

  " Show to next entry.
  execute 'cc ' . a:lastline

  " Move focus back to quickfix listing.
  execute "normal \<C-W>\<C-P>"
endfunction
