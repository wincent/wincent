" For the time-being, not automatically loading this plug-in, so need to do this
" manually:
"
"     :packadd LanguageClient-neovim
"     :LanguageClientStart
"
" (Convenience comand for that: `:LSP`)
"
if has('nvim')
  " <Leader>f -- Format buffer.
  nnoremap <Leader>f :call LanguageClient_textDocument_formatting()<CR>

  " gd -- go to definition
  nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>

  " K -- lookup keyword
  nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
endif
