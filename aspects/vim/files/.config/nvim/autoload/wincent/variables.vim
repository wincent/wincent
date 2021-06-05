function! wincent#variables#init() abort
  " Set up shortcut variables for "hash -d" directories.
  let l:dirs=system(
        \ 'zsh -c "' .
        \ 'source ~/.zsh/hash; ' .
        \ 'hash -d"'
        \ )
  let l:lines=split(l:dirs, '\n')
  for l:line in l:lines
    let l:pair=split(l:line, '=')
    if len(l:pair) == 2
      let l:var=l:pair[0]
      let l:dir=l:pair[1]

      " Make sure we don't clobber any pre-existing variables.
      if !exists('$' . l:var)
        execute 'let $' . l:var . '="' . l:dir . '"'
      endif
    endif
  endfor
endfunction
