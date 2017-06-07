function! s:SetUpLoupeHighlight()
  highlight! link Search Underlined
endfunction

if has('autocmd')
  augroup WincentLoupe
    autocmd!
    autocmd ColorScheme * call s:SetUpLoupeHighlight()
  augroup END
endif
