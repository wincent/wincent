-- "Supertab" like functionality (where tab auto-completes or jumps between
-- insertion nodes in snippets) is based on:
-- https://github.com/L3MON4D3/Luasnip/issues/1

-- Convenience wrapper around `nvim_replace_termcodes()`.
--
-- Converts a string representation of a mapping's RHS (eg. "<Tab>") into an
-- internal representation (eg. "\t").
local rhs = function(rhs_str)
  return vim.api.nvim_replace_termcodes(rhs_str, true, true, true)
end

-- Degrade gracefully if `:packadd` of LuaSnip is ever commented out.
local _, luasnip = pcall(function()
  return require'luasnip'
end)

-- Returns true if the cursor is in leftmost column or at a whitespace
-- character.
local in_whitespace = function()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.api.nvim_get_current_line():sub(col, col):match('%s')
end

local c_e = function()
  if vim.fn.pumvisible() == 1 then
    return vim.fn['compe#close']()
  elseif luasnip and luasnip.choice_active() then
    return rhs('<Plug>luasnip-next-choice')
  else
    return rhs('<C-e>')
  end
end

local c_y = function()
  if vim.fn.pumvisible() == 1 then
    return vim.fn['compe#confirm']()
  else
    return rhs('<C-y>')
  end
end

local cr = function()
  if vim.fn.pumvisible() == 1 then
    return vim.fn['compe#confirm']()
  else
    return rhs('<CR>')
  end
end

local shift_tab = function()
  if vim.fn.pumvisible() == 1 then
    return rhs('<C-p>')
  elseif luasnip and luasnip.jumpable(-1) then
    return rhs('<Plug>luasnip-jump-prev')
  else
    return rhs('<S-Tab>')
  end
end

local shift_width = function()
  if vim.o.softtabstop <= 0 then
    return vim.fn.shiftwidth()
  else
    return vim.o.softtabstop
  end
end

-- Complement to `smart_tab()`.
--
-- When 'noexpandtab' is set (ie. hard tabs are in use), backspace:
--
--    - On the left (ie. in the indent) will delete a tab.
--    - On the right (when in trailing whitespace) will delete enough
--      spaces to get back to the previous tabstop.
--    - Everywhere else it will just delete the previous character.
--
-- For other buffers ('expandtab'), we let Neovim behave as standard and that
-- yields intuitive behavior.
local smart_bs = function ()
  if vim.o.expandtab then
    return rhs('<BS>')
  else
    local col = vim.fn.col('.')
    local line = vim.api.nvim_get_current_line()
    local prefix = line:sub(1, col)
    local in_leading_indent = prefix:find('^%s*$')
    if in_leading_indent then
      return rhs('<BS>')
    end
    local previous_char = prefix:sub(#prefix, #prefix)
    if previous_char ~= ' ' then
      return rhs('<BS>')
    end
    -- Delete enough spaces to take us back to the previous tabstop.
    --
    -- Originally I was calculating the number of <BS> to send, but
    -- Neovim has some special casing that causes one <BS> to delete
    -- multiple characters even when 'expandtab' is off (eg. if you hit
    -- <BS> after pressing <CR> on a line with trailing whitespace and
    -- Neovim inserts whitespace to match.
    --
    -- So, turn 'expandtab' on temporarily and let Neovim figure out
    -- what a single <BS> should do.
    --
    -- See `:h i_CTRL-\_CTRL-O`.
    return rhs('<C-\\><C-o>:set expandtab<CR><BS><C-\\><C-o>:set noexpandtab<CR>')
  end
end

-- In buffers where 'noexpandtab' is set (ie. hard tabs are in use), <Tab>:
--
--    - Inserts a tab on the left (for indentation).
--    - Inserts spaces everywhere else (for alignment).
--
-- For other buffers (ie. where 'expandtab' applies), we use spaces everywhere.
local smart_tab = function()
  if vim.o.expandtab then
    return rhs('<Tab>') -- Neovim will insert spaces.
  else
    local col = vim.fn.col('.')
    local line = vim.api.nvim_get_current_line()
    local prefix = line:sub(1, col)
    local in_leading_indent = prefix:find('^%s*$')
    if in_leading_indent then
      return rhs('<Tab>') -- Neovim will insert a hard tab.
    else
      -- virtcol() returns last column occupied, so if cursor is on a
      -- tab it will report `actual column + tabstop` instead of `actual
      -- column`. So, get last column of previous character instead, and
      -- add 1 to it.
      local sw = shift_width()
      local previous_char = prefix:sub(#prefix, #prefix)
      local previous_column = #prefix - #previous_char + 1
      local current_column = vim.fn.virtcol({vim.fn.line('.'), previous_column}) + 1
      local remainder = (current_column - 1) % sw
      local move = remainder == 0 and sw or sw - remainder
      return (' '):rep(move)
    end
  end
end

local tab = function()
  if vim.fn.pumvisible() == 1 then
    if vim.fn.pum_getpos().size == 1 then
      -- There is only one completion and it is selected. Complete it.
      return vim.fn['compe#confirm']()
    else
      return rhs('<C-n>')
    end
  elseif luasnip and luasnip.expand_or_jumpable() then
    return rhs('<Plug>luasnip-expand-or-jump')
  elseif in_whitespace() then
    return smart_tab()
  else
    -- Would like to send smart_tab() here if there is no completion available,
    -- but `compe#complete()` is async, so we can't wait for it...
    return vim.fn['compe#complete']()
  end
end


Wincent = {
  map_callbacks = {}
}

local callback_index = 0

-- TODO: For completeness, should have unmap() too.
local map = function (mode, lhs, rhs, opts)
  local rhs_type = type(rhs)
  if rhs_type == 'function' then
    local key = '_' .. callback_index
    callback_index = callback_index + 1
    Wincent.map_callbacks[key] = rhs
    rhs = 'v:lua.Wincent.map_callbacks.' .. key .. '()'
  elseif rhs_type ~= 'string' then
    error('map(): unsupported rhs type: ' .. rhs_type)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end

-- Shallow table merge, merges `source` into `dest`, mutating it.
--
-- Returns the modified `dest` table.
local merge = function (dest, source)
  for k, v in pairs(source) do
    dest[k] = v
  end
  return dest
end

local imap = function (lhs, rhs, opts) map('i', lhs, rhs, opts) end
local inoremap = function (lhs, rhs, opts) map('i', lhs, rhs, merge(opts, {noremap = true})) end
local smap = function (lhs, rhs, opts) map('s', lhs, rhs, opts) end
local snoremap = function (lhs, rhs, opts) map('s', lhs, rhs, merge(opts, {noremap = true})) end

-- TODO: re-assess these to see which should be noremap
imap('<C-e>', c_e, {expr = true, silent = true})
imap('<C-y>', c_y, {expr = true, silent = true})
imap('<Tab>', tab, {expr = true, silent = true})
inoremap('<BS>', smart_bs, {expr = true})
inoremap('<C-j>', 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', {expr = true})
inoremap('<C-k>', 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', {expr = true})
inoremap('<CR>', cr, {expr = true, silent = true})
inoremap('<Down>', 'pumvisible() ? "\\<C-n>" : "\\<Down>"', {expr = true})
inoremap('<S-Tab>', shift_tab, {expr = true, silent = true})
inoremap('<Up>', 'pumvisible() ? "\\<C-p>" : "\\<Up>"', {expr = true})

smap('<C-e>', c_e, {expr = true, silent = true})
smap('<CR>', cr, {expr = true, silent = true})
snoremap('<S-Tab>', shift_tab, {expr = true, silent = true})
snoremap('<Tab>', tab, {expr = true, silent = true})
