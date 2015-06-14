" TODO: handle motions
function! qf#delete()
  let l:list = getqflist()
  let l:start = line('v')
  let l:end = line('.')
  let l:line = l:start

  " BUG: in visual mode, this function gets called once per line, which means
  " the following doesn't work (line numbers change, making subsequent deletions
  " invalid)
  while l:line >= l:start && l:line <= l:end
    " Non-dictionary items will be ignored. This effectively deletes the line.
    let l:list[l:line - 1] = 0
    let l:line = l:line + 1
  endwhile
  call setqflist(l:list)
endfunction
