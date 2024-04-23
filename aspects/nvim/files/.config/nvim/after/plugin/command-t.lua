local command = wincent.vim.command

--
-- Mappings.
--

-- Lua version doesn't come with any bindings of its own, so we do need to set
-- these up.

vim.keymap.set('n', '<Leader>b', '<Plug>(CommandTBuffer)')
vim.keymap.set('n', '<Leader>h', '<Plug>(CommandTHelp)')
vim.keymap.set('n', '<Leader>t', '<Plug>(CommandTRipgrep)')

-- Note: These ones come from the Ruby version, for now.

vim.keymap.set('n', '<LocalLeader>c', '<Plug>(CommandTCommand)')
vim.keymap.set('n', '<LocalLeader>h', '<Plug>(CommandTHistory)')
vim.keymap.set('n', '<LocalLeader>l', '<Plug>(CommandTLine)')

show = function()
  vim.cmd('CommandT')
  error('`:CommandTBoot` is deprecated; use `:CommandT` instead')
end

command('CommandTBoot', show)
