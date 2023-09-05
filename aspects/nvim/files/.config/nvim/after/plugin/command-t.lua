local command = wincent.vim.command

-- NOTE: With the move to the Lua version, most of the following settings have
-- no effect; instead, see the `commandt.setup()` call in
-- ~/.config/nvim/init.lua.

--
-- Settings.
--

vim.g.CommandTCancelMap = { '<ESC>', '<C-c>' }

local term = vim.api.nvim_get_option('term') -- because `vim.o.term` goes 💥

if vim.regex('screen|tmux|xterm'):match_str(term) then
  vim.g.CommandTSelectNextMap = { '<C-j>', '<Down>', '<ESC>OB' }
  vim.g.CommandTSelectPrevMap = { '<C-k>', '<Up>', '<ESC>OA' }
end

vim.g.CommandTEncoding = 'UTF-8'
vim.g.CommandTFileScanner = 'watchman'
vim.g.CommandTInputDebounce = 50
vim.g.CommandTMaxCachedDirectories = 10
vim.g.CommandTMaxFiles = 3000000
vim.g.CommandTScanDotDirectories = 1
vim.g.CommandTTraverseSCM = 'pwd'
vim.g.CommandTWildIgnore = vim.o.wildignore
  .. ',*/.git/*'
  .. ',*/.hg/*'
  .. ',*/bower_components/*'
  .. ',*/tmp/*'
  .. ',*.class'
  .. ',*/classes/*'
  .. ',*/build/*'

-- Allow Command-T to open selections in dirvish windows.
vim.g.CommandTWindowFilter = '!&buflisted && &buftype == "nofile" && &filetype !=# "dirvish"'

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
