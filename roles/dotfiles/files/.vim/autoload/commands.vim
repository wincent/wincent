function s:preview(file)
  " TODO: remove this hack once new version of Marked 2 is out:
  " http://support.markedapp.com/discussions/questions/8670
  silent! execute "!xattr -d com.apple.quarantine " . shellescape(a:file)
  silent execute "!open -a 'Marked 2.app' " . shellescape(a:file)
endfunction

function commands#preview(...)
  if a:0 == 0
    call s:preview(expand('%'))
  else
    for l:file in a:000
      call s:preview(l:file)
    endfor
  endif
endfunction
