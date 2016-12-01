function! variables#init() abort
  " Set up shortcut variables for "hash -d" directories.
  let l:dirs=system(
        \ 'zsh -c "' .
        \ 'test -e ~/.zsh/common.private && ' .
        \ 'source ~/.zsh/common.private; ' .
        \ 'hash -d"'
        \ )
  let l:lines=split(l:dirs, '\n')
  for l:line in l:lines
    let l:pair=split(l:line, '=')
    let l:var=l:pair[0]
    let l:dir=l:pair[1]

    " Make sure we don't clobber any pre-existing variables.
    if !exists('$' . l:var)
      execute 'let $' . l:var . '="' . l:dir . '"'
    endif
  endfor
endfunction
