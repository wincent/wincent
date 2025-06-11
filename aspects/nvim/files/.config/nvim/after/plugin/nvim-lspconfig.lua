wincent.lsp.init()

wincent.vim.augroup('WincentLanguageClientAutocmds', function(autocmd)
  autocmd('ColorScheme', '*', wincent.lsp.set_up_highlights)
end)
