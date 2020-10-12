if !has('nvim')
  finish
endif

lua require'wincent.lsp'.init()

sign define LspDiagnosticsErrorSign text=✖
sign define LspDiagnosticsWarningSign text=⚠
sign define LspDiagnosticsInformationSign text=ℹ
sign define LspDiagnosticsHintSign text=➤

augroup WincentLanguageClientAutocmds
  autocmd!
  autocmd ColorScheme * lua require'wincent.lsp'.set_up_highlights()
  autocmd WinEnter * lua require'wincent.lsp'.bind()
augroup END
