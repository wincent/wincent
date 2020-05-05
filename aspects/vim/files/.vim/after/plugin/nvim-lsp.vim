:lua << END
  require'nvim_lsp'.ocamlls.setup{}
  require'nvim_lsp'.tsserver.setup{}
  require'nvim_lsp'.vimls.setup{}
END

highlight link LspDiagnosticsError User8

" BUG: this doesn't work if we do it eagerly here; works if you do defer it
call wincent#defer#defer(
      \ "execute 'highlight LspDiagnosticsErrorSign ' . pinnacle#highlight({" .
      \   "'bg': pinnacle#extract_bg('ColorColumn')," .
      \   "'fg': pinnacle#extract_fg('ErrorMsg')" .
      \ "})"
      \ )

sign define LspDiagnosticsErrorSign text=✖
sign define LspDiagnosticsWarningSign text=⚠
sign define LspDiagnosticsInformationSign text=ℹ
sign define LspDiagnosticsHintSign text=➤

nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>

augroup WincentLanguageClientAutocmds
  autocmd!

  if has('nvim') && exists('*nvim_open_win')
    " TODO: figure out how to detect lsp floating window...
    " Can use floating window.
    autocmd BufEnter __LanguageClient__ call s:Bind()
  endif
augroup END
