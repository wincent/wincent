" Replaces newlines with spaces.
function! functions#sub_newlines(string) abort
  return tr(a:string, "\r\n", '  ')
endfunction

" Runs a command and returns the captured output as a single line.
"
" Useful when we don't want to let long lines on narrow windows produce unwanted
" embedded newlines.
function! functions#capture_line(command) abort
  redir => l:capture
  execute a:command
  redir END

  return functions#sub_newlines(l:capture)
endfunction

" Gets the current value of a highlight group.
function! functions#capture_highlight(group) abort
  return functions#capture_line('silent highlight ' . a:group)
endfunction

" Find a highlight group and augment it with "italic" styling, returning a
" string suitable for passing to `:hi`. Most of this logic is borrowed from:
" http://stackoverflow.com/a/1333025
function! functions#italicize_group(group) abort
  let l:group = functions#capture_highlight(a:group)

  " Traverse links back to authoritative group.
  while l:group =~# 'links to'
    let l:index = stridx(l:group, 'links to') + len('links to')
    let l:linked = strpart(l:group, l:index + 1)
    let l:group = functions#capture_highlight(l:linked)
  endwhile

  " Extract the highlighting details (the bit after "xxx")
  let l:matches = matchlist(l:group, '\<xxx\>\s\+\(.*\)')
  let l:original = l:matches[1]

  for l:lhs in ['gui', 'term', 'cterm']
    " Check for existing setting.
    let l:matches = matchlist(
      \   l:original,
      \   '^\([^ ]\+ \)\?' .
      \   '\(' . l:lhs . '=[^ ]\+\)' .
      \   '\( .\+\)\?$'
      \ )
    if l:matches == []
      " No setting, add one with just "italic" in it
      let l:original .= ' ' . l:lhs . '=italic'
    else
      " Existing setting; check whether "italic" is already in it.
      let l:start = l:matches[1]
      let l:value = l:matches[2]
      let l:end = l:matches[3]
      if l:value =~# '.*italic.*'
        continue
      else
        let l:original = l:start . l:value . ',italic' . l:end
      endif
    endif
  endfor

  return functions#sub_newlines(l:original)
endfunction

" Switch to plaintext mode with: call functions#plaintext()
function! functions#plaintext()
  setlocal linebreak
  setlocal nolist
  setlocal spell
  setlocal textwidth=0
  setlocal wrap
  setlocal wrapmargin=0

  nnoremap <buffer> j gj
  nnoremap <buffer> k gk
  nnoremap <buffer> <Down> gj
  nnoremap <buffer> <Up> gk
endfunction
