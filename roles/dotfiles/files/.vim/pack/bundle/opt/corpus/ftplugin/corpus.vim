autocmd BufWritePost <buffer> call corpus#buf_write_post()
autocmd BufWritePre <buffer> call corpus#buf_write_pre()

nnoremap <silent> <buffer> <C-]> :call corpus#goto()<CR>
