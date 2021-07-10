-- Turn on spell-checking.
local spell = function()
  vim.opt_local.spell = true
  vim.opt_local.spellfile = vim.fn.expand('~/.config/nvim/spell/en.utf-8.add')
  vim.opt_local.spelllang = 'en,es'
end

return spell
