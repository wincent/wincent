" Cycle through relativenumber + number, number (only), and no numbering.
function! mappings#cycle_numbering() abort
  if exists('+relativenumber')
    execute {
          \ '00': 'set relativenumber   | set number',
          \ '01': 'set norelativenumber | set number',
          \ '10': 'set norelativenumber | set nonumber',
          \ '11': 'set norelativenumber | set number' }[&number . &relativenumber]
  else
    " No relative numbering, just toggle numbers on and off.
    set number!<CR>
  endif
endfunction

" Zap trailing whitespace.
function! mappings#zap() abort
  let l:pos=getcurpos()
  let l:search=@/
  keepjumps %substitute/\s\+$//e
  let @/=l:search
  nohlsearch
  call setpos('.', l:pos)
endfunction

" Does the heavy-lifting for the quick find-and-replace command (:Substitute).
function! mappings#substitute(patterns) abort
  if match(a:patterns, '\v^/[^/]*/[^/]*/$') != 0
    echomsg 'Invalid patterns: ' . a:patterns
    echomsg 'Expected patterns of the form "/foo/bar/".'
    return
  endif
  if getregtype('s') != ''
    let l:register=getreg('s')
  endif
  normal! qs
  redir => l:replacements
  try
    execute ',$s' . a:patterns . 'gce#'
  catch /^Vim:Interrupt$/
    return
  finally
    normal! q
    let l:transcript=getreg('s')
    if exists('l:register')
      call setreg('s', l:register)
    endif
  endtry
  redir END
  if len(l:replacements) > 0
    " At least one instance of pattern was found.
    let l:last=strpart(l:transcript, len(l:transcript) - 1)
    if l:last ==# 'l' || l:last ==# 'q' || l:last ==# ''
      " User bailed.
      return
    endif
  endif

  " Loop around to top of file and continue.
  " Avoid unwanted "Backwards range given, OK to swap (y/n)?" messages.
  if line("''") > 1
    1,''-&&"
  endif
endfunction
