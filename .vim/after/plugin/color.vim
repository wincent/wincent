" Called with explicit "background" and "visibility" parameters, sets the
" background ("light" or "dark") and whitespace visibility ("high" or "low").
"
" Without an explicit parameter, cycles through:
"
"   Solarized light, low visibility
"   Solarized light, high visibility
"   Solarized dark, low visibility
"   Solarized dark, high visibility
"
function! s:CycleColorScheme(background, visibility)
  if strlen(a:background) != 0 && strlen(a:visibility) != 0
    let background = a:background
    let visibility = a:visibility
  else
    let current = &background . ':' .g:solarized_visibility
    let next = { 'light:low':  ['light', 'high'],
               \ 'light:high': ['dark',  'low'],
               \ 'dark:low':   ['dark',  'high'],
               \ 'dark:high':  ['light', 'low'] }[current]

    let background = next[0]
    let visibility = next[1]
  end

  let g:solarized_visibility = visibility
  color solarized
  execute "set background=" . background

  " MatchParen highlighting is hard to see; make it more obvious
  let ctermbg = background == 'light' ? 7 : 8
  execute "highlight MatchParen ctermbg=" . ctermbg .
        \ " ctermfg=11 cterm=underline term=underline"
endfunction

" mnemonic: [w]hitespace
nnoremap <leader>w :call <SID>CycleColorScheme('', '')<CR>

call s:CycleColorScheme('light', 'low')
