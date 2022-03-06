--
-- Normal mode mappings.
--

local indent_wrap_mapping = wincent.plugins.indent_blankline.wrap_mapping
local nnoremap = wincent.vim.nnoremap
local noremap = wincent.vim.noremap

-- Toggle fold at current position.
nnoremap('<Tab>', indent_wrap_mapping('za'), {silent = true})

-- Other indent-related remaps for compatibility with indent-blankline.nvim:
nnoremap('zA', indent_wrap_mapping('zA'), {silent = true})
nnoremap('zC', indent_wrap_mapping('zC'), {silent = true})
nnoremap('zM', indent_wrap_mapping('zM'), {silent = true})
nnoremap('zO', indent_wrap_mapping('zO'), {silent = true})
nnoremap('zR', indent_wrap_mapping('zR'), {silent = true})
nnoremap('zX', indent_wrap_mapping('zX'), {silent = true})
nnoremap('za', indent_wrap_mapping('za'), {silent = true})
nnoremap('zc', indent_wrap_mapping('zc'), {silent = true})
nnoremap('zm', indent_wrap_mapping('zm'), {silent = true})
nnoremap('zo', indent_wrap_mapping('zo'), {silent = true})
nnoremap('zr', indent_wrap_mapping('zr'), {silent = true})
nnoremap('zv', indent_wrap_mapping('zv'), {silent = true})
nnoremap('zx', indent_wrap_mapping('zx'), {silent = true})
nnoremap('<<', indent_wrap_mapping('<<'), {silent = true})
nnoremap('>>', indent_wrap_mapping('>>'), {silent = true})

-- Relying on Karabiner-Elements (macOS) or Interception Tools (Linux) to avoid
-- collision between <Tab> and <C-i> (have it send F6 instead for <C-i>).
nnoremap('<F6>', '<C-i>')

-- Avoid unintentional switches to Ex mode.
nnoremap('Q', '<Nop>')

-- Note this one is multi-mode mappings (Normal, Visual, Operating-pending modes).
noremap('Y', 'y$')

nnoremap('<C-h>', '<C-w>h')
nnoremap('<C-j>', '<C-w>j')
nnoremap('<C-k>', '<C-w>k')
nnoremap('<C-l>', '<C-w>l')

-- Repurpose cursor keys (accessible near homerow via "SpaceFN" layout) for one
-- of my most oft-use key sequences.
nnoremap('<Up>', ':cprevious<CR>', {silent = true})
nnoremap('<Down>', ':cnext<CR>', {silent = true})
nnoremap('<Left>', ':cpfile<CR>', {silent = true})
nnoremap('<Right>', ':cnfile<CR>', {silent = true})

nnoremap('<S-Up>', ':lprevious<CR>', {silent = true})
nnoremap('<S-Down>', ':lnext<CR>', {silent = true})
nnoremap('<S-Left>', ':lpfile<CR>', {silent = true})
nnoremap('<S-Right>', ':lnfile<CR>', {silent = true})

-- Store relative line number jumps in the jumplist if they exceed a threshold.
nnoremap('k', function () return (vim.v.count > 5 and "m'" .. vim.v.count or '') .. 'k' end, {expr = true})
nnoremap('j', function () return (vim.v.count > 5 and "m'" .. vim.v.count or '') .. 'j' end, {expr = true})
