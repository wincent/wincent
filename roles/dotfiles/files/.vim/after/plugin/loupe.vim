" - Copy `Search` highlight to `LoupeHighlight`
" - Link `Search` to `VisualNOS`
function! s:SetUpLoupeHighlight()
  execute 'highlight! LoupeHighlight ' . pinnacle#extract_highlight('Search')
  highlight! link Search VisualNOS
endfunction

if has('autocmd')
  augroup WincentLoupe
    autocmd!
    autocmd ColorScheme * call s:SetUpLoupeHighlight()
  augroup END
endif

" We have a bit of a race here:
"
" - "after/plugin/color.vim" does a `doautocmd ColorScheme`.
" - But that fires _before_ we've loaded.
" - It also sets up a `FocusGained` autocmd that fires `ColorScheme`.
" - Inside tmux, that fires on startup.
" - But _sometimes_, it seems that it fires before "after/plugin/loupe.vim".
" - Outside tmux, it doesn't fire.
" - So, some of the time, Loupe ends up trying to use LoupeHighlight before it's
"   been set up, leading to "E28: No such highlight group name: LoupeHighlight".
" - To circumvent that, we execute eagerly here; worst case scenario we end up
"   doing it redundantly a second time right after the color scheme has been
"   reset.
"
call s:SetUpLoupeHighlight()

let g:LoupeHighlightGroup='LoupeHighlight'
