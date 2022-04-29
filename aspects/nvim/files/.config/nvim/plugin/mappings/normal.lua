--
-- Normal mode mappings.
--

local indent_wrap_mapping = wincent.plugins.indent_blankline.wrap_mapping

-- Toggle fold at current position.
vim.keymap.set('n', '<Tab>', indent_wrap_mapping('za'), {silent = true})

-- Other indent-related remaps for compatibility with indent-blankline.nvim:
vim.keymap.set('n', 'zA', indent_wrap_mapping('zA'), {silent = true})
vim.keymap.set('n', 'zC', indent_wrap_mapping('zC'), {silent = true})
vim.keymap.set('n', 'zM', indent_wrap_mapping('zM'), {silent = true})
vim.keymap.set('n', 'zO', indent_wrap_mapping('zO'), {silent = true})
vim.keymap.set('n', 'zR', indent_wrap_mapping('zR'), {silent = true})
vim.keymap.set('n', 'zX', indent_wrap_mapping('zX'), {silent = true})
vim.keymap.set('n', 'za', indent_wrap_mapping('za'), {silent = true})
vim.keymap.set('n', 'zc', indent_wrap_mapping('zc'), {silent = true})
vim.keymap.set('n', 'zm', indent_wrap_mapping('zm'), {silent = true})
vim.keymap.set('n', 'zo', indent_wrap_mapping('zo'), {silent = true})
vim.keymap.set('n', 'zr', indent_wrap_mapping('zr'), {silent = true})
vim.keymap.set('n', 'zv', indent_wrap_mapping('zv'), {silent = true})
vim.keymap.set('n', 'zx', indent_wrap_mapping('zx'), {silent = true})
vim.keymap.set('n', '<<', indent_wrap_mapping('<<'), {silent = true})
vim.keymap.set('n', '>>', indent_wrap_mapping('>>'), {silent = true})

-- Relying on Karabiner-Elements (macOS) or Interception Tools (Linux) to avoid
-- collision between <Tab> and <C-i> (have it send F6 instead for <C-i>).
vim.keymap.set('n', '<F6>', '<C-i>')

-- Avoid unintentional switches to Ex mode.
vim.keymap.set('n', 'Q', '<Nop>')

-- Note this one is a rare multi-mode mapping (Normal, Operating-pending, Visual modes).
vim.keymap.set({'n', 'o', 'v'}, 'Y', 'y$')

vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

-- Repurpose cursor keys (accessible near homerow via "SpaceFN" layout) for one
-- of my most oft-use key sequences.
vim.keymap.set('n', '<Up>', ':cprevious<CR>', {silent = true})
vim.keymap.set('n', '<Down>', ':cnext<CR>', {silent = true})
vim.keymap.set('n', '<Left>', ':cpfile<CR>', {silent = true})
vim.keymap.set('n', '<Right>', ':cnfile<CR>', {silent = true})

vim.keymap.set('n', '<S-Up>', ':lprevious<CR>', {silent = true})
vim.keymap.set('n', '<S-Down>', ':lnext<CR>', {silent = true})
vim.keymap.set('n', '<S-Left>', ':lpfile<CR>', {silent = true})
vim.keymap.set('n', '<S-Right>', ':lnfile<CR>', {silent = true})

-- Store relative line number jumps in the jumplist if they exceed a threshold.
vim.keymap.set('n', 'k', function () return (vim.v.count > 5 and "m'" .. vim.v.count or '') .. 'k' end, {expr = true})
vim.keymap.set('n', 'j', function () return (vim.v.count > 5 and "m'" .. vim.v.count or '') .. 'j' end, {expr = true})
