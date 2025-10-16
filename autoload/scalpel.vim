" Copyright 2016-present Greg Hurrell. All rights reserved.
" Licensed under the terms of the MIT license.

function! scalpel#cword(curpos) abort
  " <cword> Doesn't work usefully in visual mode (always returns first word),
  " so fake it.
  let l:line=getline(a:curpos[1])
  let l:col=a:curpos[2]
  let l:chars=split(l:line, '\zs')
  let l:word=[]

  " Look for keyword characters rightwards.
  for l:char in l:chars[(l:col):]
    if match(l:char, '\k') != -1
      call add(l:word, l:char)
    else
      break
    endif
  endfor

  " Look for keyword characters leftwards.
  for l:char in reverse(l:chars[:(l:col) - 1])
    if match(l:char, '\k') != -1
      call insert(l:word, l:char, 0)
    else
      break
    endif
  endfor

  return join(l:word, '')
endfunction

function s:g()
  return &gdefault ? '' : 'g'
endfunction

" a:lastline is effectively reserved (see `:h a:lastline`), so use _lastline
" instead.
function s:replacements(currentline, _lastline, patterns, g)
  let s:report=&report
  try
    set report=10000
    execute a:currentline . ',' . a:_lastline . 's' . a:patterns . a:g . 'ce#'
  catch /^Vim:Interrupt$/
    execute 'set report=' . s:report
    return
  finally
    normal! q
    let s:transcript=getreg('s')
    if exists('s:register')
      call setreg('s', s:register)
    endif
  endtry
endfunction

function! scalpel#substitute(patterns, line1, line2, count) abort
  if a:count == -1
    " No range supplied, operate on whole buffer.
    let l:currentline=a:line1
    let l:firstline=1
    let l:lastline=line('$')
  else
    let l:firstline=a:line1 <= a:line2 ? a:line1 : a:line2
    let l:lastline=a:line2 >= a:line2 ? a:line2 : a:line1
    let l:currentline=l:firstline
  endif

  let l:g=s:g()

  " As per `:h E146`, can use any single-byte non-alphanumeric character as
  " delimiter except for backslash, quote, and vertical bar.
  if match(a:patterns, '\v^([^"\\|A-Za-z0-9 ]).*\1.*\1$') != 0
    echomsg 'Invalid patterns: ' . a:patterns
    echomsg 'Expected patterns of the form "/foo/bar/".'
    return
  endif
  if getregtype('s') != ''
    let s:register=getreg('s')
  elseif exists('s:register')
    unlet s:register
  endif
  normal! qs

  if exists('*execute')
    let l:replacements=execute('call s:replacements(l:currentline, l:lastline, a:patterns, l:g)', '')
  else
    redir => l:replacements
    call s:replacements(l:currentline, l:lastline, a:patterns, l:g)
    redir END
  endif

  if len(l:replacements) > 0
    " At least one instance of pattern was found.
    let l:last=strpart(s:transcript, len(s:transcript) - 1)
    if l:last ==# 'l' || l:last ==# 'q' || l:last ==# ''
      " User bailed.
      return
    elseif l:last ==# 'a'
      " Loop around to top of range/file and continue.
      " Avoid unwanted "Backwards range given, OK to swap (y/n)?" messages.
      if l:currentline > l:firstline
        " Drop c flag.
        execute l:firstline . ',' . l:currentline . '-&' . l:g . 'ce'
      endif
     return
    endif
  endif

  " Loop around to top of range/file and continue.
  " Avoid unwanted "Backwards range given, OK to swap (y/n)?" messages.
  if l:currentline > l:firstline
    execute l:firstline . ',' . l:currentline . '-&' .l:g . 'ce'
    execute 'set report=' . s:report
  endif
endfunction
