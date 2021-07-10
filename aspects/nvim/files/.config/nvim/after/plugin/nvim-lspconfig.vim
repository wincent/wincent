lua require'wincent.lsp'.init()

sign define LspDiagnosticsSignError text=✖
sign define LspDiagnosticsSignWarning text=⚠
sign define LspDiagnosticsSignInformation text=ℹ
sign define LspDiagnosticsSignHint text=➤

augroup WincentLanguageClientAutocmds
  autocmd!
  autocmd ColorScheme * lua require'wincent.lsp'.set_up_highlights()
augroup END
