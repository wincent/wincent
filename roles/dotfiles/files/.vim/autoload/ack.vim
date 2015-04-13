function s:escape(arg)
  " The basic strategy is to split on spaces, shellescape each word, and join.
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
  return substitute(join(map(split(substitute(a:arg, '\\ ', '<!!S!!>', 'g')), 'shellescape(v:val)')), '<!!S!!>', ' ', 'g')
endfunction

function! ack#ack(command)
  if empty(&grepprg)
    return
  endif
  cexpr system(&grepprg . ' ' . s:escape(a:command))
  cwindow
endfunction

function! ack#lack(command)
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
function! ack#acks(command)
  if match(a:command, '\v^/.+/.*/$') == -1 " crude sanity check
    throw 'Expected a substitution expression (/foo/bar/); got: ' . a:command
  endif

  let l:filenames = QuickfixFilenames()
  if l:filenames ==# ''
    throw 'Quickfix filenames must be present, but there are none'
  endif

  execute 'args' l:filenames
  execute 'argdo' '%s' . a:command . 'ge | update'
endfunction

" Populate the :args list with the filenames currently in the quickfix window.
function! ack#qargs()
  let l:buffer_numbers = {}
  for l:item in getqflist()
    let l:buffer_numbers[l:item['bufnr']] = bufname(l:item['bufnr'])
  endfor
  return join(map(values(l:buffer_numbers), 'fnameescape(v:val)'))
endfunction
