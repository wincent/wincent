" For the time-being, not automatically loading this plug-in, so need to do this
" manually:
"
"     :packadd LanguageClient-neovim
"     :LanguageClientStart
"
" (Convenience comand for that: `:LSP`)
"
if has('nvim')
  function! s:Config()
    if has_key(g:LanguageClient_serverCommands, &filetype)
      if &filetype == 'reason'
        " Format selection with gq.
        setlocal formatexpr=LanguageClient#textDocument_rangeFormatting_sync()

        " <Leader>f -- Format buffer.
        nnoremap <buffer> <silent> <Leader>f :call LanguageClient_textDocument_formatting()<CR>
      endif

      " gd -- go to definition
      nnoremap <buffer> <silent> gd :call LanguageClient#textDocument_definition()<CR>

      " K -- lookup keyword
      nnoremap <buffer> <silent> K :call LanguageClient#textDocument_hover()<CR>
    endif
  endfunction
endif

autocmd FileType * call s:Config()
