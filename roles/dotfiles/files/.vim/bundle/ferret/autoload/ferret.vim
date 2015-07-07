" Copyright 2015-present Greg Hurrell. All rights reserved.
" Licensed under the terms of the BSD 2-clause license.

" The basic strategy is to split on spaces, expand wildcards for non-option
" arguments, shellescape each word, and join.
"
" To support an edge-case (the ability to search for strings with spaces in
" them, however, we swap out escaped spaces first (subsituting the unlikely
" "<!!S!!>") and then swap them back in at the end. This allows us to perform
" searches like:
"
"   :Ack -i \bFoo_?Bar\b
"   :Ack that's\ nice\ dear
"
" and so on...
function! s:escape(arg) abort
  let l:escaped_spaces_replaced_with_markers=substitute(a:arg, '\\ ', '<!!S!!>', 'g')
  let l:split_on_spaces=split(l:escaped_spaces_replaced_with_markers)

  let l:seen_search_pattern=0
  let l:expanded_args=[]
  for l:arg in l:split_on_spaces
    if l:arg =~# '^-'
      " Options get passed through as-is.
      call add(l:expanded_args, l:arg)
    elseif l:seen_search_pattern
      let l:file_args=glob(l:arg, 1, 1) " Ignore 'wildignore', return a list.
      if len(l:file_args)
        call extend(l:expanded_args, l:file_args)
      else
        " Let through to `ag`/`ack`/`grep`, which will throw ENOENT.
        call add(l:expanded_args, l:arg)
      endif
    else
      " First non-option arg is considered to be search pattern.
      let l:seen_search_pattern=1
      call add(l:expanded_args, l:arg)
    endif
  endfor

  let l:each_word_shell_escaped=map(l:expanded_args, 'shellescape(v:val)')
  let l:joined=join(l:each_word_shell_escaped)
  return substitute(l:joined, '<!!S!!>', ' ', 'g')
endfunction

function! ferret#ack(command) abort
  if empty(&grepprg)
    return
  endif

  let l:original_makeprg=&l:makeprg
  let l:original_errorformat=&l:errorformat
  try
    let &l:makeprg=&grepprg . ' ' . s:escape(a:command)
    let &l:errorformat=&grepformat
    Make
  finally
    let &l:makeprg=l:original_makeprg
    let &l:errorformat=l:original_errorformat
  endtry
endfunction

function! ferret#lack(command) abort
  if empty(&grepprg)
    return
  endif
  lexpr system(&grepprg . ' ' . s:escape(a:command))
  lwindow
endfunction

" Run the specified substitution command on all the files in the quickfix list
" (mnemonic: "Ack substitute").
"
" Specifically, the sequence:
"
"   :Ack foo
"   :Acks /foo/bar/
"
" is equivalent to:
"
"   :Ack foo
"   :Qargs
"   :argdo %s/foo/bar/ge | update
"
" (Note: there's nothing specific to Ack in this function; it's just named this
" way for mnemonics, as it will most often be preceded by an :Ack invocation.)
function! ferret#acks(command) abort
  if match(a:command, '\v^/.+/.*/$') == -1 " crude sanity check
    echoerr 'Ferret: Expected a substitution expression (/foo/bar/); got: ' . a:command
    return
  endif

  let l:filenames=ferret#qargs()
  if l:filenames ==# ''
    echoerr 'Ferret: Quickfix filenames must be present, but there are none'
    return
  endif

  execute 'args' l:filenames
  execute 'argdo' '%s' . a:command . 'ge | update'
endfunction

" Populate the :args list with the filenames currently in the quickfix window.
function! ferret#qargs() abort
  let l:buffer_numbers={}
  for l:item in getqflist()
    let l:buffer_numbers[l:item['bufnr']]=bufname(l:item['bufnr'])
  endfor
  return join(map(values(l:buffer_numbers), 'fnameescape(v:val)'))
endfunction
