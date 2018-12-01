autocmd BufNewFile,BufRead *{_spec,Spec,-test,\.test}.js set ft=javascript.jest

autocmd FileType javascript call s:Test()

function s:Test()
  let l:file=expand('<afile>')
  let l:filetype=expand('<amatch>')
  if match(l:filetype, '\v<jest>') != -1
    return
  endif
  if match(l:file, '\v(_spec|Spec|-test|\.test)\.js$') != -1
    noautocmd set filetype=javascript.jest
  endif
endfunction
