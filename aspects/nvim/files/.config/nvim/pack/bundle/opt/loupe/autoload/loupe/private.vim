" Copyright 2015-present Greg Hurrell. All rights reserved.
" Licensed under the terms of the BSD 2-clause license.

" If you have a "special" character in your 'iskeyword' setting (eg. something
" like `:set iskeyword=@,34,39,41,47-57,92,_,124,192-255,134`, where 134 is a
" backslash), then Vim's own star command will fail to jump to the next keyword,
" printing an error like:
"
"     E486: Pattern not found: \<foo\bar\>
"
" We can avoid this by escaping all backslashes and running in "very nomagic"
" mode (ie. \V).
function! loupe#private#escape(cword) abort
  return substitute(a:cword, '\\', '\\\\', 'g')
endfunction

" Dynamically returns slash or slash-followed-by-"\v" depending on the location
" of the just-typed slash within the command-line. Only a slash that looks to
" be at the start of a command gets replaced. What the "slash" itself is is
" configurable via the `slash` argument, meaning that this function can be used
" in conjunction with other pattern delimiters like "?" and "@" etc (ie. "?" ->
" "?\v", "@" -> "@\v").
"
" Doesn't handle the full list of possible range types (specified in `:h
" cmdline-ranges`), but catches the most common ones.
function! loupe#private#very_magic_slash(slash) abort
  if getcmdtype() != ':'
    return a:slash
  endif

  " For simplicity, only consider a slash typed at the end of the command-line.
  let l:pos=getcmdpos()
  let l:cmd=getcmdline()
  if len(l:cmd) + 1 != l:pos
    return a:slash
  endif

  " Skip over ranges
  while 1
    let l:stripped=s:strip_ranges(l:cmd)
    if l:stripped ==# l:cmd
      break
    else
      let l:cmd=l:stripped
    endif
  endwhile

  " We special case `:g!` (and `gl!`, `glo!`, `glob!`, `globa!`, `global!`).
  " All of those commands are equivalent to `:v` (ie. `!` is not being used as a
  " slash). Using `!` with `:v` (etc) is an error (`:h E477`). Using it with `:s`
  " is ok (it _is_ treated as a delimiter there). Fun fact: `:g!!foo!d` is a
  " legitmate command.
  if index(['g', 'gl', 'glo', 'glob', 'globa', 'global'], l:cmd != 1) && a:slash == '!'
    return a:slash
  elseif index([
        \   'g', 'gl', 'glo', 'glob', 'globa', 'global',
        \   'g!', 'gl!', 'glo!', 'glob!', 'globa!', 'global!',
        \   's', 'su', 'sub', 'subs', 'subst', 'substi', 'substit', 'substitu', 'substitut', 'substitute',
        \   'v', 'vg', 'vgl', 'vglo', 'vglob', 'vgloba', 'vglobal',
        \ ], l:cmd) != -1
    return loupe#private#prepare_highlight(a:slash . '\v')
  endif

  return a:slash
endfunction

function! s:strip_ranges(cmdline)
  let l:cmdline=a:cmdline

  " All the range tokens may be followed (several times) by '+' or '-' and an
  " optional number.
  let l:modifier='\([+-]\d*\)*'

  " Range tokens as specified in `:h cmdline-ranges`.
  let l:cmdline=substitute(l:cmdline, '^\d\+' . l:modifier, '', '') " line number
  let l:cmdline=substitute(l:cmdline, '^\.' . l:modifier, '', '') " current line
  let l:cmdline=substitute(l:cmdline, '^$' . l:modifier, '', '') " last line in file
  let l:cmdline=substitute(l:cmdline, '^%' . l:modifier, '', '') " entire file
  let l:cmdline=substitute(l:cmdline, "^'[a-z]\\c" . l:modifier, '', '') " mark t (or T)
  let l:cmdline=substitute(l:cmdline, "^'[<>]" . l:modifier, '', '') " visual selection marks
  let l:cmdline=substitute(l:cmdline, '^/[^/]\+/' . l:modifier, '', '') " /{pattern}/
  let l:cmdline=substitute(l:cmdline, '^?[^?]\+?' . l:modifier, '', '') " ?{pattern}?
  let l:cmdline=substitute(l:cmdline, '^\\/' . l:modifier, '', '') " \/ (next match of previous pattern)
  let l:cmdline=substitute(l:cmdline, '^\\?' . l:modifier, '', '') " \? (last match of previous pattern)
  let l:cmdline=substitute(l:cmdline, '^\\&' . l:modifier, '', '') " \& (last match of previous substitution)

  " Separators (see: `:h :,` and `:h :;`).
  let l:cmdline=substitute(l:cmdline, '^,', '', '') " , (separator)
  let l:cmdline=substitute(l:cmdline, '^;', '', '') " ; (separator)

  return l:cmdline
endfunction

" Prepare to highlight the match as soon as the cursor moves to it.
function! loupe#private#prepare_highlight(result) abort
  if has('autocmd')
    augroup LoupeHightlightMatch
      autocmd!
      autocmd CursorMoved * :call loupe#hlmatch()
    augroup END
  endif
  return a:result
endfunction

" Clear previously applied match highlighting.
function! loupe#private#clear_highlight() abort
  if exists('w:loupe_hlmatch')
    try
      call matchdelete(w:loupe_hlmatch)
    catch /\v(E802|E803)/
      " https://github.com/wincent/loupe/issues/1
    finally
      unlet w:loupe_hlmatch
    endtry
  endif
endfunction

" Called from WinEnter autocmd to clean up stray `matchadd()` vestiges.
" If we switch into a window and there is no 'hlsearch' in effect but we do have
" a `w:loupe_hlmatch` variable, it means that `:nohighight` was probably run
" from another window and we should clean up the straggling match and the
" window-local variable.
function! loupe#private#cleanup() abort
  if !exists('v:hlsearch') || !v:hlsearch
    call loupe#private#clear_highlight()
  endif
endfunction
