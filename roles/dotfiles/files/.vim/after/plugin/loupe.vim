if has('autocmd')
  augroup WincentLoupe
    autocmd!

    " - Copy `Search` highlight to `LoupeHighlight`
    " - Link `Search` to `VisualNOS`
    autocmd ColorScheme * execute 'highlight! LoupeHighlight ' . functions#extract_highlight('Search') | highlight! link Search VisualNOS
  augroup END
endif

let g:LoupeHighlightGroup='LoupeHighlight'
