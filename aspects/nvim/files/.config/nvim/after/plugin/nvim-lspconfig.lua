local augroup = require('wincent.nvim.augroup')

wincent.lsp.init()

augroup('WincentLanguageClientAutocmds', function(autocmd)
  autocmd('ColorScheme', '*', wincent.lsp.set_up_highlights)
end)
