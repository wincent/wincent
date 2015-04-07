function s:CheckColorScheme()
  let g:base16colorspace=256

  let s:config_file = expand('~/.vim/.base16')

  if filereadable(s:config_file)
    let s:config = readfile(s:config_file, '', 2)

    if s:config[1] =~ '^dark\|light$'
      exe 'set background=' . s:config[1]
    else
      echoerr 'Bad background ' . s:config[1] . ' in ' . s:config_file
    endif

    if filereadable(expand('~/.vim/bundle/base16-vim/colors/base16-' . s:config[0] . '.vim'))
      exe 'color base16-' . s:config[0]
    else
      echoerr 'Bad scheme ' . s:config[0] . ' in ' . s:config_file
    endif
  else " default
    set background=light
    color base16-tomorrow
  endif

  exe 'hi Comment ' . ItalicizeGroup('Comment')

  " Give statusline.vim a chance to re-set User1
  doautocmd ColorScheme
endfunction

augroup WincentAutocolor
  autocmd!
  autocmd FocusGained * call s:CheckColorScheme()
augroup END

" TODO: only set background/color if something actually changed
call s:CheckColorScheme()
