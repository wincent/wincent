autocmd FileType * call s:Test()

function! s:Test()
  if match(&filetype, '\v<javascript|javascriptreact|typescript|typescriptreact>') == -1
    return
  endif

  if match(&filetype, '\v<jest>') != -1
    return
  endif

  let l:file=expand('<afile>')

  if match(l:file, '\v(Spec|Test|-spec|\.spec|_spec|-test|\.test|_test)\.(js|jsx|ts|tsx)$') != -1 ||
        \ match(l:file, '\v/__tests__|tests?/.+\.(js|jsx|ts|tsx)$') != -1
    noautocmd set filetype+=.jest
  endif
endfunction
