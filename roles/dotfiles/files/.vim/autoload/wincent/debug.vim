function! wincent#debug#log(string) abort
  call writefile([a:string], '/tmp/wincent-vim-debug.txt', 'aS')
endfunction
