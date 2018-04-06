function! s:ScanFile()
  let n = 1
  let nmax = line('$')
  if line('$') > 500
    let nmax = 500
  endif
  while n < nmax
    if getline(n) =~# "\\v<React\\."
      return 1
      break
    endif
    let n = n + 1
  endwhile
  return 0
endfunction

function! s:DetectJSX(file)
  if a:file =~# "\\v\\.html"
    if s:ScanFile()
      set ft=html.jsx
    endif
  elseif a:file =~# "\\v(_spec|Spec|-test|\\.test)\\.js"
    if s:ScanFile()
      set ft=javascript.jest.jsx
    endif
  elseif a:file =~# "\\v\\.js"
    if s:ScanFile()
      set ft=javascript.jsx
    endif
  endif
endfunction

autocmd BufNewFile,BufRead *.js.jsx set ft=javascript.jsx
autocmd BufNewFile,BufRead *.html,*.js call s:DetectJSX(expand("<afile>"))
