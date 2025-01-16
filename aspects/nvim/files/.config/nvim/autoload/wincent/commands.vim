function! s:open(app, file)
  if !executable('open')
    echoerr 'No "open" executable'
    return
  endif

  silent execute '!open -a ' . shellescape(a:app) . ' ' . shellescape(a:file)
endfunction

function! s:marked(file) abort
  " TODO: remove this hack once new version of Marked 2 is out:
  " http://support.markedapp.com/discussions/questions/8670
  silent! execute '!xattr -d com.apple.quarantine ' . shellescape(a:file)
  call s:open('Marked 2.app', a:file)
endfunction

function! wincent#commands#find(args) abort
    set errorformat+=%f

    " TODO: make this async
    cexpr system('find ' . a:args)
endfunction

function! wincent#commands#glow(file) abort
  if !executable('glow')
    echoerr 'No glow executable found'
    return
  end
  if empty(a:file)
    let l:file=expand('%')
  else
    let l:file=a:file
  endif
  if !empty(l:file)
    let l:file=shellescape(l:file)
  endif

  " Make sure LESS doesn't include the problematic `F` option, which
  " causes the pager to exit immediately if output fits on less than one
  " screen.
  execute 'Spawn env LESS="-iMRX" glow --local --pager ' . l:file
endfunction

function! wincent#commands#lint() abort
  " TODO: make this smart about which compiler plug-in to used based on location

  " Make subsequent `:make` work (eg. invoked by Dispatch's `m<CR>` mapping).
  compiler eslint

  " Do an immediate Make.
  Make
endfunction

function! wincent#commands#marked(file) abort
  if empty(a:file)
    call s:marked(expand('%'))
  else
    call s:marked(a:file)
  endif
endfunction

function! wincent#commands#preview(file) abort
  if executable('open')
    call wincent#commands#marked(a:file)
  elseif executable('glow')
    call wincent#commands#glow(a:file)
  else
    echoerr 'No "open" or "glow" executable found'
  endif
endfunction

function! wincent#commands#typecheck() abort
  " Make subsequent `:make` work (eg. invoked by Dispatch's `m<CR>` mapping).
  compiler tsc

  " Do an immediate Make.
  Make
endfunction

function! wincent#commands#vim() abort
  let l:filename=expand('%:p')
  if empty(l:filename)
    echoerr 'No current file'
    return
  endif

  let l:url=shellescape(l:filename)

  " Break up the string literal here to stop Vim from thinking it's a modeline
  " and freaking out with:
  "
  "   E518: Unknown option: //'
  "
  call system('open vim' . '://' . l:url)
endfunction
