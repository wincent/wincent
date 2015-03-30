scriptencoding utf-8

" cf the default statusline: %<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
if has('statusline')
  set statusline=%n   " buffer number
  set statusline+=:   " (literal)
  set statusline+=%<  " truncation point, if not enough width available
  set statusline+=%f  " relative path to file
  set statusline+=\   " space
  set statusline+=%1* " switch to User1 highlight group (italics)

  " needs to be all on one line:
  "   %(                   start item group
  "   [                    left bracket (literal)
  "   %M                   modified flag: ,+/,- (modified/unmodifiable) or nothing
  "   %R                   read-only flag: ,RO or nothing
  "   %{statusline#Ft()}   filetype (not using %Y because I don't want caps)
  "   %{statusline#Fenc()} file-encoding if not UTF-8
  "   ]                    right bracket (literal)
  "   %)                   end item group
  set statusline+=%([%M%R%{statusline#Ft()}%{statusline#Fenc()}]%)

  set statusline+=%*   " reset highlight group
  set statusline+=%=   " split point for left and right groups
  set statusline+=\    " space
  set statusline+=ℓ    " (literal, \u2113 "SCRIPT SMALL L")
  set statusline+=\    " space
  set statusline+=%l   " current line number
  set statusline+=/    " separator
  set statusline+=%L   " number of lines in buffer
  set statusline+=\    " space
  set statusline+=@    " (literal)
  set statusline+=\    " space
  set statusline+=%c   " current column number
  set statusline+=%V   " current virtual column number (-n), if different
  set statusline+=\    " space
  set statusline+=%1*  " switch to User1 highlight group (italics)
  set statusline+=%p   " percentage through buffer
  set statusline+=%%   " literal %
  set statusline+=%*   " reset highlight group

  function! statusline#Ft()
    if strlen(&ft)
      return ',' . &ft
    else
      return ''
    endif
  endfunction

  function! statusline#Fenc()
    if strlen(&fenc) && &fenc != 'utf-8'
      return ',' . &fenc
    else
      return ''
    endif
  endfunction

  " (Re-)create User1 highlight group, based on StatusLine group but with
  " italics added; most of this logic is borrowed from:
  " http://stackoverflow.com/a/1333025
  function s:UpdateUser1()
    redir => l:group
    exe 'silent hi StatusLine'
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

    " Actually (re-)create the group.
    exe 'hi User1 ' . l:original
  endfunction

  augroup statusline
    autocmd!
    autocmd ColorScheme * call s:UpdateUser1()
  augroup END
endif
