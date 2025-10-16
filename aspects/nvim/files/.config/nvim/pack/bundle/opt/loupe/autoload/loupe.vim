" Copyright 2015-present Greg Hurrell. All rights reserved.
" Licensed under the terms of the BSD 2-clause license.

""
" @function loupe#hlmatch
"
" Apply highlighting to the current search match.
"
function! loupe#hlmatch() abort
  ""
  " @option g:LoupeHighlightGroup string IncSearch
  " Specifies the |:highlight| group used to emphasize the match currently under
  " the cursor for the current search pattern. Defaults to "IncSearch" (ie.
  " |hl-IncSearch|). For example:
  "
  " ```
  " let g:LoupeHighlightGroup='Error'
  " ```
  "
  " To prevent any special highlighting from being applied, set this option to
  " "" (ie. the empty string).
  let l:highlight=get(g:, 'LoupeHighlightGroup', 'IncSearch')
  if empty(l:highlight)
    return
  endif

  if has('autocmd')
    augroup LoupeHightlightMatch
      autocmd!
    augroup END
  endif

  call loupe#private#clear_highlight()

  " \c case insensitive
  " \%# current cursor position
  " @/ current search pattern
  let l:pattern='\c\%#' . @/

  if exists('*matchadd')
    try
      let w:loupe_hlmatch=matchadd(l:highlight, l:pattern)
    catch /.*/
      " Invalid search pattern.
    endtry
  endif
endfunction
