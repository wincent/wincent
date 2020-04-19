function! s:ScanFile()
  let n = 1
  let nmax = line('$')
  if line('$') > 500
    let nmax = 500
  endif
  while n < nmax
    if getline(n) =~# "\\v<React>"
      return 1
      break
    endif
    let n = n + 1
  endwhile
  return 0
endfunction

function! s:DetectJSX()
  if match(&filetype, '\v<jsx>') != -1
    return
  endif
  if s:ScanFile()
    call s:SetJSX()
  endif
endfunction

function! s:SetJSX()
  noautocmd set filetype+=.jsx

  if exists(':LanguageClientStart') == 2
    LanguageClientStart
  endif
endfunction

autocmd BufNewFile,BufRead *.js.jsx,*.jsx call s:SetJSX()
autocmd BufNewFile,BufRead *.html,*.js call s:DetectJSX()
