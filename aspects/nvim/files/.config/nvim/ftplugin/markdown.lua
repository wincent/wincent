wincent.vim.plaintext()

wincent.vim.setlocal('breakindent')
wincent.vim.setlocal('breakindentopt', 'sbr,shift:' .. vim.bo.shiftwidth)
wincent.vim.setlocal('synmaxcol', 0)

local has_treesitter = pcall(require, 'nvim-treesitter')
if has_treesitter then
  vim.opt_local.foldmethod = 'expr'
  vim.opt_local.foldexpr = 'nvim_treesitter#foldexpr()'
end
