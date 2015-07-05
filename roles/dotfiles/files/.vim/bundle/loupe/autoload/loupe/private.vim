" Copyright 2015-present Greg Hurrell. All rights reserved.
" Licensed under the terms of the BSD 2-clause license.

" Dynamically returns "/" or "/\v" depending on the location of the just-typed
" "/" within the command-line. Only "/" that looks to be at the start of a
" command gets replaced.
"
" Doesn't handle the full list of possible range types (specified in `:h
" cmdline-ranges`), but catches the most common ones.
function! loupe#private#very_magic_slash() abort
  if getcmdtype() != ':'
    return '/'
  endif

  " For simplicity, only consider "/" typed at the end of the command-line.
  let l:pos = getcmdpos()
  let l:cmd = getcmdline()
  if len(l:cmd) + 1 != l:pos
    return '/'
  endif

  " Skip over ranges
  while 1
    let l:stripped = s:strip_ranges(l:cmd)
    if l:stripped ==# l:cmd
      break
    else
      let l:cmd = l:stripped
    endif
  endwhile

  if index(['g', 's', 'v'], l:cmd) != -1
    return loupe#private#prepare_highlight('/\v')
  endif

  return '/'
endfunction

function! s:strip_ranges(cmdline)
  let l:cmdline = a:cmdline

  " All the range tokens may be followed (several times) by '+' or '-' and an
  " optional number.
  let l:modifier = '\([+-]\d*\)*'

  " Range tokens as specified in `:h cmdline-ranges`.
  " Separators as specified in `:h :,` and `:h :;`.
  for l:pattern in [
        \   '^\d\+',
        \   '^\.',
        \   '^$',
        \   '^%',
        \   "^'[a-z]\\c",
        \   "^'[<>]",
        \   '^/[^/]\+/',
        \   '^?[^?]\+?',
        \   '^\\/',
        \   '^\\?',
        \   '^\\&',
        \   '^,',
        \   '^;'
        \ ]
    let l:cmdline = substitute(l:cmdline, l:pattern . l:modifier, '', '')
  endfor

  return l:cmdline
endfunction

" Prepare to highlight the match as soon as the cursor moves to it.
function! loupe#private#prepare_highlight(result) abort
  if has('autocmd')
    augroup LoupeHightlightMatch
      autocmd!
      autocmd CursorMoved * :call loupe#private#hlmatch()
    augroup END
  endif
  return a:result
endfunction

" Clear previously applied match highlighting.
function! loupe#private#clear_highlight() abort
  if exists('w:loupe_hlmatch')
    call matchdelete(w:loupe_hlmatch)
    unlet w:loupe_hlmatch
  endif
endfunction

" Called from WinEnter autocmd to clean up stray `matchadd()` vestiges.
" If we switch into a window and there is no 'hlsearch' in effect but we do have
" a `w:loupe_hlmatch` variable, it means that `:nohighight` was probably run
" from another window and we should clean up the straggling match and the
" window-local variable.
function! loupe#private#cleanup() abort
  if !v:hlsearch
    call loupe#private#clear_highlight()
  endif
endfunction

" Apply highlighting to the current search match.
function! loupe#private#hlmatch() abort
  " When g:loupeHighlight is set (and it is set to "IncSearch" by default), use
  " that highlight group to make the current search result stand out.
  let l:highlight = exists('g:LoupeHighlightGroup') ? g:LoupeHighlightGroup : 'IncSearch'
  if empty(l:highlight)
    return
  endif

  if has('autocmd')
    augroup LoupeHightlightMatch
      autocmd!
    augroup END
  endif

  call loupe#private#clear_highlight()

  " \c case insensitive
  " \%# current cursor position
  " @/ current search pattern
  let l:pattern = '\c\%#' . @/

  if exists('*matchadd')
    let w:loupe_hlmatch = matchadd(l:highlight, l:pattern)
  endif
endfunction
