function! s:SetUpLoupeHighlight()
  highlight! clear Search
  execute 'highlight! Search ' . pinnacle#embolden('Underlined')
endfunction

if has('autocmd')
  augroup WincentLoupe
    autocmd!
    autocmd ColorScheme * call s:SetUpLoupeHighlight()
  augroup END
endif
