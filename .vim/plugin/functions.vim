" Find a highlight group and augment it with "italic" styling, returning a
" string suitable for passing to `:hi`. Most of this logic is borrowed from:
" http://stackoverflow.com/a/1333025
function ItalicizeGroup(group)
  redir => l:group
  exe 'silent hi ' . a:group
  redir END

  " Traverse links back to authoritative group.
  while l:group =~ 'links to'
    let l:index = stridx(l:group, 'links to') + len('links to')
    let l:linked = strpart(l:group, l:index + 1)
    redir => l:group
    exe 'silent hi ' . l:linked
    redir END
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
      if l:value =~ '.*italic.*'
        continue
      else
        let l:original = l:start . l:value . ',italic' . l:end
      endif
    endif
  endfor

  return l:original
endfunction
