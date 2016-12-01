" Subset from plugin/statusline.vim (can't comment inline with line continuation
" markers without Vim freaking out).
let g:WincentQuickfixStatusline =
      \ 'Quickfix'
      \ . '%<'
      \ . '\ '
      \ . '%='
      \ . '\ '
      \ . 'ℓ'
      \ . '\ '
      \ . '%l'
      \ . '/'
      \ . '%L'
      \ . '\ '
      \ . '@'
      \ . '\ '
      \ . '%c'
      \ . '%V'
      \ . '\ '
      \ . '%1*'
      \ . '%p'
      \ . '%%'
      \ . '%*'

" Set up shortcut variables for "hash -d" directories.
let s:dirs=system(
      \ 'zsh -c "' .
      \ 'test -e ~/.zsh/common.private && ' .
      \ 'source ~/.zsh/common.private; ' .
      \ 'hash -d"'
      \ )
let s:lines=split(s:dirs, '\n')
for s:line in s:lines
  let s:pair=split(s:line, '=')
  let s:var=s:pair[0]
  let s:dir=s:pair[1]

  " Make sure we don't clobber any pre-existing variables.
  if !exists('$' . s:var)
    execute 'let $' . s:var . '="' . s:dir . '"'
  endif
endfor
