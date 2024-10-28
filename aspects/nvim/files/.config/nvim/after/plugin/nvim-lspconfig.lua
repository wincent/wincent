wincent.lsp.init()

-- See also: https://github.com/neovim/nvim-lspconfig/wiki/UI-customization#change-diagnostic-symbols-in-the-sign-column-gutter
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '✖',
      [vim.diagnostic.severity.HINT] = '➤',
      [vim.diagnostic.severity.INFO] = 'ℹ',
      [vim.diagnostic.severity.WARN] = '⚠',
    },
    texthl = {
      [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
      [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
      [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
      [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
      [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
      [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
      [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
    },
  },
})

wincent.vim.augroup('WincentLanguageClientAutocmds', function()
  wincent.vim.autocmd('ColorScheme', '*', wincent.lsp.set_up_highlights)
end)
