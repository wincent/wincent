local wincent = require'wincent'

local setlocal = wincent.vim.setlocal

-- Disable haskell-vim omnifunc
vim.g.haskellmode_completion_ghc = 0

setlocal('omnifunc', 'necoghc#omnifunc')
