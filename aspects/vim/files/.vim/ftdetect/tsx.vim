function! s:SetTSX()
  noautocmd set filetype+=.tsx

  if exists(':LanguageClientStart') == 2
    LanguageClientStart
  endif
endfunction

autocmd BufNewFile,BufRead *.tsx call s:SetTSX()
