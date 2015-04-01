function Clip()
  call system('nc localhost 8377', @0)
endfunction

command! Clip call Clip()

nnoremap <leader>y :Clip<CR>
