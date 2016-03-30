" Replaces newlines with spaces.
function! pinnacle#sub_newlines(string) abort
  return tr(a:string, "\r\n", '  ')
endfunction

" Runs a command and returns the captured output as a single line.
"
" Useful when we don't want to let long lines on narrow windows produce unwanted
" embedded newlines.
function! pinnacle#capture_line(command) abort
  redir => l:capture
  execute a:command
  redir END

  return pinnacle#sub_newlines(l:capture)
endfunction

" Gets the current value of a highlight group.
function! pinnacle#capture_highlight(group) abort
  return pinnacle#capture_line('silent highlight ' . a:group)
endfunction

" Extracts a highlight string from a group, recursively traversing linked
" groups, and returns a string suitable for passing to `:highlight`.
function! pinnacle#extract_highlight(group) abort
  let l:group = pinnacle#capture_highlight(a:group)

  " Traverse links back to authoritative group.
  while l:group =~# 'links to'
    let l:index = stridx(l:group, 'links to') + len('links to')
    let l:linked = strpart(l:group, l:index + 1)
    let l:group = pinnacle#capture_highlight(l:linked)
  endwhile

  " Extract the highlighting details (the bit after "xxx")
  let l:matches = matchlist(l:group, '\<xxx\>\s\+\(.*\)')
  let l:original = l:matches[1]
  return l:original
endfunction

" Returns an italicized copy of `group` suitable for passing to `:highlight`.
function! pinnacle#italicize(group) abort
  return pinnacle#decorate('italic', a:group)
endfunction

" Returns a bold copy of `group` suitable for passing to `:highlight`.
function! pinnacle#embolden(group) abort
  return pinnacle#decorate('bold', a:group)
endfunction

" Returns a copy of `group` decorated with `style` (eg. "bold", "italic" etc)
" suitable for passing to `:highlight`.
function! pinnacle#decorate(style, group) abort
  let l:original = pinnacle#extract_highlight(a:group)

  for l:lhs in ['gui', 'term', 'cterm']
    " Check for existing setting.
    let l:matches = matchlist(
      \   l:original,
      \   '^\([^ ]\+ \)\?' .
      \   '\(' . l:lhs . '=[^ ]\+\)' .
      \   '\( .\+\)\?$'
      \ )
    if l:matches == []
      " No setting, add one with just a:style in it
      let l:original .= ' ' . l:lhs . '=' . a:style
    else
      " Existing setting; check whether a:style is already in it.
      let l:start = l:matches[1]
      let l:value = l:matches[2]
      let l:end = l:matches[3]
      if l:value =~# '.*' . a:style . '.*'
        continue
      else
        let l:original = l:start . l:value . ',' . a:style . l:end
      endif
    endif
  endfor

  return pinnacle#sub_newlines(l:original)
endfunction
