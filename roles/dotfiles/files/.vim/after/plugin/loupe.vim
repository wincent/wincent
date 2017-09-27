function! s:SetUpLoupeHighlight()
  execute 'highlight! QuickFixLine ' . pinnacle#extract_highlight('PmenuSel')

  highlight! clear Search
  execute 'highlight! Search ' . pinnacle#embolden('Underlined')
endfunction

if has('autocmd')
  augroup WincentLoupe
    autocmd!
    autocmd ColorScheme * call s:SetUpLoupeHighlight()
  augroup END
endif
