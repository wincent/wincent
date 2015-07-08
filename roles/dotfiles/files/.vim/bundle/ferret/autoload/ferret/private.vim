" Copyright 2015-present Greg Hurrell. All rights reserved.
" Licensed under the terms of the BSD 2-clause license.

" Remove lines a:first through a:last from the quickfix listing.
function! s:delete(first, last)
  let l:list=getqflist()
  let l:line=a:first

  while l:line >= a:first && l:line <= a:last
    " Non-dictionary items will be ignored. This effectively deletes the line.
    let l:list[l:line - 1]=0
    let l:line=l:line + 1
  endwhile
  call setqflist(l:list, 'r')

  " Show to next entry.
  execute 'cc ' . a:first

  " Move focus back to quickfix listing.
  execute "normal \<C-W>\<C-P>"
endfunction

" Escape space-delimited arguments for use by `system()`.
"
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

function! ferret#private#ack(command) abort
  if empty(&grepprg)
    return
  endif

  " Prefer vim-dispatch unless otherwise instructed.
  let l:dispatch = exists('g:FerretDispatch') ? g:FerretDispatch : 1
  if l:dispatch && exists(':Make') == 2
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
  else
    cexpr system(&grepprg . ' ' . s:escape(a:command))
    cwindow
  endif
endfunction

function! ferret#private#lack(command) abort
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
function! ferret#private#acks(command) abort
  if match(a:command, '\v^/.+/.*/$') == -1 " crude sanity check
    echoerr 'Ferret: Expected a substitution expression (/foo/bar/); got: ' . a:command
    return
  endif

  let l:filenames=ferret#private#qargs()
  if l:filenames ==# ''
    echoerr 'Ferret: Quickfix filenames must be present, but there are none'
    return
  endif

  execute 'args' l:filenames
  execute 'argdo' '%s' . a:command . 'ge | update'
endfunction

" Populate the :args list with the filenames currently in the quickfix window.
function! ferret#private#qargs() abort
  let l:buffer_numbers={}
  for l:item in getqflist()
    let l:buffer_numbers[l:item['bufnr']]=bufname(l:item['bufnr'])
  endfor
  return join(map(values(l:buffer_numbers), 'fnameescape(v:val)'))
endfunction

" Visual mode deletion and `dd` mapping (special case).
function! ferret#private#qf_delete() range
  call s:delete(a:firstline, a:lastline)
endfunction

" Motion-based deletion from quickfix listing.
function! ferret#private#qf_delete_motion(type, ...)
  " Save.
  let l:selection=&selection
  let &selection='inclusive'

  let l:firstline=line("'[")
  let l:lastline=line("']")
  call s:delete(l:firstline, l:lastline)

  " Restore.
  let &selection=l:selection
endfunction
