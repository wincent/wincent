autocmd FileType javascript,typescript call s:Test()

function! s:Test()
  let l:file=expand('<afile>')
  if match(&filetype, '\v<jest>') != -1
    return
  endif
  if match(l:file, '\v(_spec|Spec|-test|\.test)\.(js|jsx|ts|tsx)$') != -1 ||
        \ match(l:file, '\v/__tests__|tests?/.+\.(js|jsx|ts|tsx)$') != -1
    noautocmd set filetype+=.jest
  endif
endfunction
