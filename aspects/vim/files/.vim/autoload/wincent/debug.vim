function! wincent#debug#log(string) abort
  call writefile([a:string], '/tmp/wincent-vim-debug.txt', 'aS')
endfunction

function! wincent#debug#compiler() abort
  " TODO: add check to confirm we're in .vim/after/compiler/*.vim or similar
  source %
  call setqflist([])
  /\v^finish>/+1,$ :cgetbuffer
  copen
endfunction
