" Copyright 2015-present Greg Hurrell. All rights reserved.
" Licensed under the terms of the BSD 2-clause license.

""
"
" @option g:FerretAutojump number 1
"
" Controls whether Ferret will automatically jump to the first found match.
"
" - Set to 0, Ferret will show the search results but perform no jump.
" - Set to 1 (the default), Ferret will show the search results and
"   focus the result listing.
" - Set to 2, Ferret will show the search results and jump to the first found
"   match.
"
" Example override:
"
" ```
" let g:FerretAutojump=2
" ```
function! s:autojump()
  let l:autojump=get(g:, 'FerretAutojump', 1)
  if l:autojump != 0 && l:autojump != 1 && l:autojump != 2
    let l:autojump=1
  endif
  return l:autojump
endfunction

function! s:set_title(type, title)
  if has('patch-7.4.2200')
    if a:type ==# 'qf'
      call setqflist([], 'a', {'title' : a:title})
    else
      call setloclist(0, [], 'a', {'title' : a:title})
    endif
  elseif a:type ==# 'qf'
    let w:quickfix_title=a:title
  endif
endfunction

function! ferret#private#shared#finalize_search(output, ack)
  let l:lastsearch = get(g:, 'ferret_lastsearch', '')
  let l:original_errorformat=&errorformat
  let l:autojump=s:autojump()
  if a:ack
    let l:prefix='c' " Will use cexpr, cgetexpr.
    ""
    " @option g:FerretQFHandler string "botright copen"
    "
    " Allows you to override the mechanism that opens the |quickfix| window to
    " display search results.
    "
    let l:handler=get(g:, 'FerretQFHandler', 'botright copen')
    let l:post='qf'
  else
    let l:prefix='l' " Will use lexpr, lgetexpr.
    ""
    " @option g:FerretLLHandler string "lopen"
    "
    " Allows you to override the mechanism that opens the |location-list|
    " window to display search results.
    "
    let l:handler=get(g:, 'FerretLLHandler', 'lopen')
    let l:post='location'
  endif
  try
    let &errorformat=g:FerretFormat
    if l:autojump == 2 " Show listing and jump to first result.
      call s:swallow(l:prefix . 'expr a:1', a:output)
    else
      call s:swallow(l:prefix . 'getexpr a:1', a:output)
    endif
    call s:set_title(l:post, 'Search `' . l:lastsearch . '`')
    let l:before=winnr()
    let l:len=ferret#private#post(l:post)
    if l:len
      execute l:handler
      if l:autojump != 1 " Show listing, but don't jump anywhere.
        let l:after=winnr()
        if l:before != l:after
          execute l:before . 'wincmd w'
        end
      endif
    endif
  finally
    let &errorformat=l:original_errorformat
  endtry
endfunction

" Execute `executable` expression, swallowing errors.
" The intention is that this should catch "innocuous" errors, like a bad
" modeline causing `cexpr` to throw an error when it tries to jump to that file.
function! s:swallow(executable, ...)
  try
    execute a:executable
  catch
    echomsg 'Caught: ' . v:exception
  endtry
endfunction
