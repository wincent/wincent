wincent.vim.plaintext()

vim.opt_local.breakindent = true
vim.opt_local.breakindentopt = 'sbr,shift:' .. vim.bo.shiftwidth
vim.opt_local.synmaxcol = 0

local has_treesitter = pcall(require, 'nvim-treesitter')
if has_treesitter then
  vim.opt_local.foldmethod = 'expr'
  vim.opt_local.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

  -- Workaround for: https://github.com/neovim/neovim/issues/33926
  vim.opt_local.foldminlines = 1
end
