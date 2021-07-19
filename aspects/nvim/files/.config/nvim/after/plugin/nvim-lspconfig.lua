wincent.lsp.init()

vim.cmd [[
  sign define LspDiagnosticsSignError text=✖
  sign define LspDiagnosticsSignWarning text=⚠
  sign define LspDiagnosticsSignInformation text=ℹ
  sign define LspDiagnosticsSignHint text=➤
]]

wincent.vim.augroup('WincentLanguageClientAutocmds', function()
  wincent.vim.autocmd('ColorScheme', '*',  wincent.lsp.set_up_highlights)
end)
