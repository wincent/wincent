wincent.lsp.init()

wincent.nvim.augroup('WincentLanguageClientAutocmds', function(autocmd)
  autocmd('ColorScheme', '*', wincent.lsp.set_up_highlights)
end)
