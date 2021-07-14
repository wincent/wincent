local setlocal = wincent.vim.setlocal

-- Turn on spell-checking.
local spell = function()
  setlocal('spell')
  setlocal('spellfile', vim.fn.expand('~/.config/nvim/spell/en.utf-8.add'))
  setlocal('spelllang', 'en,es')
end

return spell
