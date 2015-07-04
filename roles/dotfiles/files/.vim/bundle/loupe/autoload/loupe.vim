" Dynamically returns "/" or "/\v" depending on the location of the just-typed
" "/" within the command-line. Only "/" that looks to be at the start of a
" command gets replaced.
"
" Doesn't handle the full list of possible range types (specified in `:h
" cmdline-ranges`), but catches the most common ones.
function! loupe#very_magic_slash() abort
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
    return loupe#prepare_highlight('/\v')
  endif

  return '/'
endfunction

function! s:strip_ranges(cmdline)
  let l:cmdline = a:cmdline

  " All the range tokens may be followed (several times) by '+' or '-' and an
  " optional number.
  let l:modifier = '\([+-]\d*\)*'

  " Range tokens as specified in `:h cmdline-ranges`.
  let l:cmdline = substitute(l:cmdline, '^\d\+' . l:modifier, '', '') " line number
  let l:cmdline = substitute(l:cmdline, '^\.' . l:modifier, '', '') " current line
  let l:cmdline = substitute(l:cmdline, '^$' . l:modifier, '', '') " last line in file
  let l:cmdline = substitute(l:cmdline, '^%' . l:modifier, '', '') " entire file
  let l:cmdline = substitute(l:cmdline, "^'[a-z]\\c" . l:modifier, '', '') " mark t (or T)
  let l:cmdline = substitute(l:cmdline, "^'[<>]" . l:modifier, '', '') " visual selection marks
  let l:cmdline = substitute(l:cmdline, '^/[^/]\+/' . l:modifier, '', '') " /{pattern}/
  let l:cmdline = substitute(l:cmdline, '^?[^?]\+?' . l:modifier, '', '') " ?{pattern}?
  let l:cmdline = substitute(l:cmdline, '^\\/' . l:modifier, '', '') " \/ (next match of previous pattern)
  let l:cmdline = substitute(l:cmdline, '^\\?' . l:modifier, '', '') " \? (last match of previous pattern)
  let l:cmdline = substitute(l:cmdline, '^\\&' . l:modifier, '', '') " \& (last match of previous substitution)

  " Separators (see: `:h :,` and `:h :;`).
  let l:cmdline = substitute(l:cmdline, '^,', '', '') " , (separator)
  let l:cmdline = substitute(l:cmdline, '^;', '', '') " ; (separator)

  return l:cmdline
endfunction

" Prepare to highlight the match as soon as the cursor moves to it.
function! loupe#prepare_highlight(result) abort
  augroup LoupeHightlightMatch
    autocmd!
    autocmd CursorMoved * :call loupe#hlmatch()
  augroup END
  return a:result
endfunction

" Clear previously applied match highlighting.
function! loupe#clear_highlight() abort
  if exists('w:hlmatch')
    call matchdelete(w:hlmatch)
    unlet w:hlmatch
  endif
endfunction

" Apply highlighting to the current search match.
function! loupe#hlmatch() abort
  augroup LoupeHightlightMatch
    autocmd!
  augroup END

  call loupe#clear_highlight()

  " \c case insensitive
  " \%# current cursor position
  " @/ current search pattern
  let l:pattern = '\c\%#' . @/
  let w:hlmatch = matchadd('IncSearch', l:pattern)
endfunction
