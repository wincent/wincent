wincent.lsp.init()

wincent.vim.augroup('WincentLanguageClientAutocmds', function()
  wincent.vim.autocmd('ColorScheme', '*', wincent.lsp.set_up_highlights)
end)
