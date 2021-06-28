" In theory you can do this with 'verbose' (>= 9) and 'verbosefile', but this
" one is a bit more specialized.
function! wincent#debug#autocmds(log) abort
  let l:log=fnamemodify(a:log, ':p')
  echomsg 'Logging to: ' . l:log

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

    execute 'autocmd ' .
          \ l:name .
          \ ' * call writefile([strftime("%Y-%m-%d %T") . " ' .
          \ l:name .
          \ ' " . fnamemodify(bufname(), ":t") . " (b:" . bufnr() . ", w:" . winnr() . ")"], "' .
          \ escape(l:log, '"\') .
          \ '", "a")'
  endfor
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
