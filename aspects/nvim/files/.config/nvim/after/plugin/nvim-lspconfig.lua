wincent.lsp.init()

-- Based on: https://github.com/neovim/nvim-lspconfig/wiki/UI-customization#change-diagnostic-symbols-in-the-sign-column-gutter
vim.fn.sign_define('DiagnosticSignError', { text = '✖', texthl = 'DiagnosticSignError', numhl = 'DiagnosticSignError' })
vim.fn.sign_define('DiagnosticSignHint', { text = '➤', texthl = 'DiagnosticSignHint', numhl = 'DiagnosticSignHint' })
vim.fn.sign_define('DiagnosticSignInfo', { text =  'ℹ', texthl = 'DiagnosticSignInfo', numhl = 'DiagnosticSignInfo' })
vim.fn.sign_define('DiagnosticSignWarn', { text =  '⚠', texthl = 'DiagnosticSignWarn', numhl = 'DiagnosticSignWarn' })

wincent.vim.augroup('WincentLanguageClientAutocmds', function()
  wincent.vim.autocmd('ColorScheme', '*',  wincent.lsp.set_up_highlights)
end)
