function! wincent#commands#find(args) abort
    set errorformat+=%f

    " TODO: make this async
    cexpr system('find ' . a:args)
endfunction

function! s:Open(app, file)
  if !executable('open')
    echoerr 'No "open" executable'
    return
  endif

  silent execute '!open -a ' . shellescape(a:app) . ' ' . shellescape(a:file)
endfunction

function! wincent#commands#lint() abort
  " TODO: make this smart about which compiler plug-in to used based on location

  " Make subsequent `:make` work (eg. invoked by Dispatch's `m<CR>` mapping).
  compiler eslint

  " Do an immediate Make.
  Make
endfunction

function! wincent#commands#mvim() abort
  let l:filename=expand('%')
  if empty(l:filename)
    echoerr 'No current file'
    return
  endif

  call s:Open('MacVim.app', l:filename)
endfunction

function! s:preview(file) abort
  " TODO: remove this hack once new version of Marked 2 is out:
  " http://support.markedapp.com/discussions/questions/8670
  silent! execute '!xattr -d com.apple.quarantine ' . shellescape(a:file)
  call s:Open('Marked 2.app', a:file)
endfunction

function! wincent#commands#preview(...) abort
  if a:0 == 0
    call s:preview(expand('%'))
  else
    for l:file in a:000
      call s:preview(l:file)
    endfor
  endif
endfunction
