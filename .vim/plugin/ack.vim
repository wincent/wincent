if executable('ag')       " The Silver Searcher: faster than ack
  let s:ackprg = 'ag --column --nocolor --nogroup'
elseif executable('ack')  " Ack: better than grep
  let s:ackprg = 'ack --column'
elseif executable('grep') " Grep: it's just grep
  let s:ackprg = &grepprg " default is: grep -n $* /dev/null
endif

if !empty(s:ackprg)
  let &grepprg=s:ackprg
  set grepformat=%f:%l:%c:%m
endif

augroup wincent_ack
  autocmd!
  autocmd QuickFixCmdPost [^l]* nested cw
  autocmd QuickFixCmdPost l* nested lw
augroup END

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
  return substitute(join(map(split(substitute(a:arg, '\ ', '<!!S!!>', 'g')), 'shellescape(v:val)')), '<!!S!!>', ' ', 'g')
endfunction

function! AckGrep(command)
  if empty(s:ackprg)
    return
  endif
  cexpr system(s:ackprg . ' ' . s:escape(a:command))
  cw
endfunction

function! LackGrep(command)
  if empty(s:ackprg)
    return
  endif
  lexpr system(s:ackprg . ' ' . s:escape(a:command))
  lw
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
function! Acks(command)
  if match(a:command, '\v^/.+/.*/$') == -1 " crude sanity check
    throw "Expected a substitution expression (/foo/bar/); got: " . a:command
  endif

  let l:filenames = QuickfixFilenames()
  if l:filenames == ''
    throw 'Quickfix filenames must be present, but there are none'
  endif

  execute 'args' l:filenames
  execute 'argdo' '%s' . a:command . 'ge | update'
endfunction

command! -nargs=+ -complete=file Ack call AckGrep(<q-args>)
nnoremap <leader>a :Ack<space>
command! -nargs=+ -complete=file Lack call LackGrep(<q-args>)
nnoremap <leader>l :Lack<space>
command! -nargs=1 Acks call Acks(<q-args>)

" call :Ack with word currently under cursor (mnemonic: selection)
nnoremap <leader>s :Ack <C-r><C-w><CR>

" populate the :args list with the filenames currently in the quickfix window
command! -bar Qargs execute 'args' QuickfixFilenames()
function! QuickfixFilenames()
  let buffer_numbers = {}
  for quickfix_item in getqflist()
    let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
  endfor
  return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction
