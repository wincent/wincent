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

-- Testing diagnostics using Lua
-- (https://github.com/LuaLS/lua-language-server/wiki/Diagnostics)

-- Uncomment this to see an ERROR diagnostic ("Unexpected <exp>").
--
-- vim.....

-- Uncomment this to see an INFO diagnostic ("Global variable in lowecase
-- initial, Did you miss `local` or misspell it?")
--
-- something = true

-- Uncomment this to see a HINT diagnostic ("Unused functions"):
--
-- local function example(); end

-- Uncomment this to see a WARN diangostic ("Compute `'hello' .. _.e` first. You
-- may need to add brackets"):
--
-- print('hello' .. _.e or 'World')

wincent.vim.augroup('WincentLanguageClientAutocmds', function()
  wincent.vim.autocmd('ColorScheme', '*', wincent.lsp.set_up_highlights)
end)
