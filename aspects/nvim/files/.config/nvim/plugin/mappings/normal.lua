--
-- Normal mode mappings.
--

-- Wraps a mapping with a call telling indent-blankline.nvim to update itself.
local wrap_mapping = require('wincent.plugins.ibl.wrap_mapping')

-- (Custom) toggle fold at current position.
vim.keymap.set('n', '<Tab>', wrap_mapping('za'), { silent = true })

-- Wrap built-in fold-related mappings.
vim.keymap.set('n', 'zA', wrap_mapping('zA'), { silent = true })
vim.keymap.set('n', 'zC', wrap_mapping('zC'), { silent = true })
vim.keymap.set('n', 'zM', wrap_mapping('zM'), { silent = true })
vim.keymap.set('n', 'zO', wrap_mapping('zO'), { silent = true })
vim.keymap.set('n', 'zR', wrap_mapping('zR'), { silent = true })
vim.keymap.set('n', 'zX', wrap_mapping('zX'), { silent = true })
vim.keymap.set('n', 'za', wrap_mapping('za'), { silent = true })
vim.keymap.set('n', 'zc', wrap_mapping('zc'), { silent = true })
vim.keymap.set('n', 'zm', wrap_mapping('zm'), { silent = true })
vim.keymap.set('n', 'zo', wrap_mapping('zo'), { silent = true })
vim.keymap.set('n', 'zr', wrap_mapping('zr'), { silent = true })
vim.keymap.set('n', 'zv', wrap_mapping('zv'), { silent = true })
vim.keymap.set('n', 'zx', wrap_mapping('zx'), { silent = true })
vim.keymap.set('n', '<<', wrap_mapping('<<'), { silent = true })
vim.keymap.set('n', '>>', wrap_mapping('>>'), { silent = true })

-- Relying on Karabiner-Elements (macOS) or Interception Tools (Linux) to avoid
-- collision between <Tab> and <C-i> (have it send F6 instead for <C-i>).
vim.keymap.set('n', '<F6>', '<C-i>')

-- Avoid unintentional switches to Ex mode.
vim.keymap.set('n', 'Q', '<Nop>')

-- Note this one is a rare multi-mode mapping (Normal, Operating-pending, Visual modes).
vim.keymap.set({ 'n', 'o', 'v' }, 'Y', 'y$')

-- Move between splits.
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

-- Resize splits (outside tmux).
vim.keymap.set('n', '<D-Up>', function()
  require('wincent.mappings.normal').resize_up()
end)
vim.keymap.set('n', '<D-Down>', function()
  require('wincent.mappings.normal').resize_down()
end)
vim.keymap.set('n', '<D-Left>', function()
  require('wincent.mappings.normal').resize_left()
end)
vim.keymap.set('n', '<D-Right>', function()
  require('wincent.mappings.normal').resize_right()
end)

-- Resize splits (inside tmux).
vim.keymap.set('n', '<M-Up>', function()
  require('wincent.mappings.normal').resize_up()
end)
vim.keymap.set('n', '<M-Down>', function()
  require('wincent.mappings.normal').resize_down()
end)
vim.keymap.set('n', '<M-Left>', function()
  require('wincent.mappings.normal').resize_left()
end)
vim.keymap.set('n', '<M-Right>', function()
  require('wincent.mappings.normal').resize_right()
end)

-- Repurpose cursor keys (accessible near home row via "SpaceFN" layout) for one
-- of my most oft-use key sequences.
vim.keymap.set('n', '<Up>', ':cprevious<CR>', { silent = true })
vim.keymap.set('n', '<Down>', ':cnext<CR>', { silent = true })
vim.keymap.set('n', '<Left>', ':cpfile<CR>', { silent = true })
vim.keymap.set('n', '<Right>', ':cnfile<CR>', { silent = true })

vim.keymap.set('n', '<S-Up>', ':lprevious<CR>', { silent = true })
vim.keymap.set('n', '<S-Down>', ':lnext<CR>', { silent = true })
vim.keymap.set('n', '<S-Left>', ':lpfile<CR>', { silent = true })
vim.keymap.set('n', '<S-Right>', ':lnfile<CR>', { silent = true })

-- Store relative line number jumps in the jumplist if they exceed a threshold.
vim.keymap.set('n', 'k', function()
  return (vim.v.count > 5 and "m'" .. vim.v.count or '') .. 'k'
end, { expr = true })
vim.keymap.set('n', 'j', function()
  return (vim.v.count > 5 and "m'" .. vim.v.count or '') .. 'j'
end, { expr = true })
