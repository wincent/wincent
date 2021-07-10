function! s:SetTSX()
  noautocmd set filetype+=.tsx
endfunction

autocmd BufNewFile,BufRead *.tsx call s:SetTSX()
