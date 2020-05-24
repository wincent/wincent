function s:RemoveBg(group)
  if !wincent#pinnacle#active()
    return
  endif

  let l:highlight=filter(pinnacle#dump(a:group), 'v:key != "bg"')
  execute 'highlight! clear ' . a:group
  execute 'highlight! ' . a:group . ' ' . pinnacle#highlight(l:highlight)
endfunction

function s:CheckColorScheme()
  if !has('termguicolors')
    let g:base16colorspace=256
  endif

  let s:config_file = expand('~/.vim/.base16')

  if filereadable(s:config_file)
    let s:config = readfile(s:config_file, '', 2)

    if s:config[1] =~# '^dark\|light$'
      execute 'set background=' . s:config[1]
    else
      echoerr 'Bad background ' . s:config[1] . ' in ' . s:config_file
    endif

    if filereadable(expand('~/.vim/pack/bundle/opt/base16-vim/colors/base16-' . s:config[0] . '.vim'))
      execute 'colorscheme base16-' . s:config[0]
    else
      echoerr 'Bad scheme ' . s:config[0] . ' in ' . s:config_file
    endif
  else " default
    set background=dark
    colorscheme base16-default-dark
  endif

  if wincent#pinnacle#active()
    execute 'highlight Comment ' . pinnacle#italicize('Comment')
  endif

  " Hide (or at least make less obvious) the EndOfBuffer region
  highlight! EndOfBuffer ctermbg=bg ctermfg=bg guibg=bg guifg=bg

  " Grey, just like we used to get with https://github.com/Yggdroot/indentLine
  if &background ==# 'light'
    let s:conceal_term_fg=249
    let s:conceal_gui_fg='Grey70'
  else
    let s:conceal_term_fg=239
    let s:conceal_gui_fg='Grey30'
  endif
  highlight clear Conceal
  execute 'highlight Conceal ' .
        \ 'ctermfg=' . s:conceal_term_fg
        \ 'guifg=' . s:conceal_gui_fg

  " Sync with corresponding non-nvim 'highlight' settings in
  " ~/.vim/plugin/settings.vim:
  highlight clear NonText
  highlight link NonText Conceal

  if wincent#pinnacle#active()
    highlight clear CursorLineNr
    execute 'highlight CursorLineNr ' . pinnacle#extract_highlight('DiffText')

    highlight clear Pmenu
    highlight link Pmenu Visual
  endif

  highlight clear DiffDelete
  highlight link DiffDelete Conceal
  highlight clear VertSplit
  highlight link VertSplit LineNr

  " Resolve clashes with ColorColumn.
  " Instead of linking to Normal (which has a higher priority, link to nothing).
  highlight link vimUserFunc NONE

  " For Git commits, suppress the background of these groups:
  for l:group in ['DiffAdded', 'DiffFile', 'DiffNewFile', 'DiffLine', 'DiffRemoved']
    call s:RemoveBg(l:group)
  endfor

  " More subtle highlighting during merge conflict resolution.
  highlight clear DiffAdd
  highlight clear DiffChange
  highlight clear DiffText

  if wincent#pinnacle#active()
    let l:highlight=pinnacle#italicize('ModeMsg')
    execute 'highlight User8 ' . l:highlight
  endif

  " Allow for overrides:
  " - `statusline.vim` will re-set User1, User2 etc.
  " - `after/plugin/loupe.vim` will override Search.
  doautocmd ColorScheme
endfunction

if v:progname !=# 'vi'
  if has('autocmd')
    augroup WincentAutocolor
      autocmd!
      autocmd FocusGained * call s:CheckColorScheme()
    augroup END
  endif

  call s:CheckColorScheme()
endif
