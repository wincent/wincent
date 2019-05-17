function! wincent#commands#find(args) abort
    set errorformat+=%f

    " TODO: make this async
    cexpr system('find ' . a:args)
endfunction

function! s:preview(file) abort
  " TODO: remove this hack once new version of Marked 2 is out:
  " http://support.markedapp.com/discussions/questions/8670
  silent! execute '!xattr -d com.apple.quarantine ' . shellescape(a:file)
  silent execute '!open -a "Marked 2.app" ' . shellescape(a:file)
endfunction

function! wincent#commands#preview(...) abort
  if a:0 == 0
    call s:preview(expand('%'))
  else
    for l:file in a:000
      call s:preview(l:file)
    endfor
  endif
endfunction
