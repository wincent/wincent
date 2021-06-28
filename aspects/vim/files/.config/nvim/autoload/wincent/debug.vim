let s:log='autocommand.log'

" In theory you can do this with 'verbose' (>= 9) and 'verbosefile', but this
" one is a bit more specialized.
function! wincent#debug#autocmds(log) abort
  let s:log=fnamemodify(a:log, ':p')
  echomsg 'Logging to: ' . s:log
  for l:name in [
        \   'BufAdd',
        \   'BufDelete',
        \   'BufEnter',
        \   'BufFilePost',
        \   'BufHidden',
        \   'BufLeave',
        \   'BufNew',
        \   'BufNewFile',
        \   'BufRead',
        \   'BufReadPost',
        \   'BufReadPre',
        \   'BufUnload',
        \   'BufWinEnter',
        \   'BufWinLeave',
        \   'BufWipeout',
        \   'BufWrite',
        \   'BufWritePost',
        \   'BufWritePre',
        \   'CursorHold',
        \   'CursorHoldI',
        \   'CursorMoved',
        \   'CursorMovedI',
        \   'FileType',
        \   'FocusGained',
        \   'FocusLost',
        \   'InsertEnter',
        \   'InsertLeave',
        \   'QuitPre',
        \   'TabClosed',
        \   'TabEnter',
        \   'TabLeave',
        \   'TabNew',
        \   'TabNewEntered',
        \   'TextYankPost',
        \   'VimEnter',
        \   'VimLeave',
        \   'VimLeavePre',
        \   'VimResized',
        \   'WinClosed',
        \   'WinEnter',
        \   'WinLeave',
        \   'WinNew'
        \ ]
    execute 'autocmd ' . l:name . ' * call <SID>LogAutocommand("' . l:name .'")'
  endfor
endfunction

function! s:LogAutocommand(name)
  let l:timestamp=strftime('%Y-%m-%d %T')
  let l:abuf=expand('<abuf>')
  let l:afile=fnamemodify(expand('<afile>'), ':t')
  if l:afile == ''
    let l:afile='...'
  endif
  let l:bufnr=bufnr()
  let l:bufnr_description=(l:bufnr == l:abuf ? l:bufnr : l:bufnr . ' [' . l:abuf . ']')
  let l:bufname=fnamemodify(bufname(), ':t')
  if l:bufname == ''
    let l:bufname='...'
  endif
  let l:bufname_description=(l:bufname == l:afile ? l:bufname : l:bufname . '/' . l:afile)
  call writefile([
        \   l:timestamp . ' ' .
        \   a:name . ' ' .
        \   l:bufname_description .
        \   ' (b:' . l:bufnr_description .
        \   ', w:' . winnr() . ')'
        \ ], s:log, 'a')
endfunction

function! wincent#debug#compiler() abort
  " TODO: add check to confirm we're in .config/nvim/after/compiler/*.vim or similar
  source %
  call setqflist([])
  /\v^finish>/+1,$ :cgetbuffer
  copen
endfunction

function! wincent#debug#log(string) abort
  call writefile([a:string], '/tmp/wincent-vim-debug.txt', 'aS')
endfunction
