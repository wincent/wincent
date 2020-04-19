" Traverses up the tree trying to find `file`.
function! wincent#compiler#find(file) abort
  let l:path=fnamemodify(expand('%') || getcwd(), ':p')

  while 1
    let l:candidate=l:path . '/' . a:file

    if filereadable(l:candidate)
      return l:candidate
    elseif l:path == '' || l:path =='/'
      return ''
    endif

    let l:path=fnamemodify(l:path, ':h')
  endwhile
endfunction
