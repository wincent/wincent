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

    if filereadable(expand('~/.vim/pack/bundle/start/base16-vim/colors/base16-' . s:config[0] . '.vim'))
      execute 'color base16-' . s:config[0]
    else
      echoerr 'Bad scheme ' . s:config[0] . ' in ' . s:config_file
    endif
  else " default
    set background=dark
    color base16-tomorrow-night
  endif

  execute 'highlight Comment ' . pinnacle#italicize('Comment')

  " Make tildes at EndOfBuffer less obvious.
  let l:color=pinnacle#extract_bg('ColorColumn')
  let l:highlight=pinnacle#highlight({'bg': l:color, 'fg': l:color})
  execute 'highlight EndOfBuffer ' . l:highlight

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
