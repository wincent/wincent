function! s:SetUpLoupeHighlight()
  execute 'highlight! QuickFixLine ' . luaeval("require'wincent.pinnacle'.extract_highlight('PmenuSel')")

  highlight! clear Search
  execute 'highlight! Search ' . luaeval("require'wincent.pinnacle'.embolden('Underlined')")
endfunction

augroup WincentLoupe
  autocmd!
  autocmd ColorScheme * call s:SetUpLoupeHighlight()
augroup END
