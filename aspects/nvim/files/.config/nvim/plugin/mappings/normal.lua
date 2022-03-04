--
-- Normal mode mappings.
--

local nnoremap = wincent.vim.nnoremap
local noremap = wincent.vim.noremap

-- Wrap all mappings related to folding so that indent-blankline.nvim can
-- update when folds are changed. See:
-- https://github.com/lukas-reineke/indent-blankline.nvim/issues/118
local fold = function(mapping)
  if vim.g.loaded_indent_blankline == 1 then
    return mapping .. ':IndentBlanklineRefresh<CR>'
  else
    return mapping
  end
end

-- Toggle fold at current position.
nnoremap('<Tab>', fold('za'), {silent = true})

-- Other fold-related remaps for compatibility with indent-blankline.nvim:
nnoremap('zA', fold('zA'), {silent = true})
nnoremap('zC', fold('zC'), {silent = true})
nnoremap('zM', fold('zM'), {silent = true})
nnoremap('zO', fold('zO'), {silent = true})
nnoremap('zR', fold('zR'), {silent = true})
nnoremap('zX', fold('zX'), {silent = true})
nnoremap('za', fold('za'), {silent = true})
nnoremap('zc', fold('zc'), {silent = true})
nnoremap('zm', fold('zm'), {silent = true})
nnoremap('zo', fold('zo'), {silent = true})
nnoremap('zr', fold('zr'), {silent = true})
nnoremap('zv', fold('zv'), {silent = true})
nnoremap('zx', fold('zx'), {silent = true})

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
