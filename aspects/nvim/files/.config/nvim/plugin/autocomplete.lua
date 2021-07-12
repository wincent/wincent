local wincent = require'wincent'

local augroup = wincent.vim.augroup
local autocmd = wincent.vim.autocmd
local imap = wincent.vim.imap
local inoremap = wincent.vim.inoremap
local smap = wincent.vim.smap
local snoremap = wincent.vim.snoremap

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

-- Degrade gracefully if `:packadd` of LuaSnip/nvim-compe are ever commented out.
local has_compe = pcall(require, 'compe')
local has_luasnip, luasnip = pcall(require, 'luasnip')

-- Returns true if the cursor is in leftmost column or at a whitespace
-- character.
local in_whitespace = function()
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.api.nvim_get_current_line():sub(col, col):match('%s')
end

local c_e = function()
  if vim.fn.pumvisible() == 1 then
    if has_compe then
      return vim.fn['compe#close']()
    else
      return rhs('<C-e>')
    end
  elseif has_luasnip and luasnip.choice_active() then
    return rhs('<Plug>luasnip-next-choice')
  else
    return rhs('<C-e>')
  end
end

local c_y = function()
  if vim.fn.pumvisible() == 1 and has_compe then
    return vim.fn['compe#confirm']()
  else
    return rhs('<C-y>')
  end
end

local cr = function()
  if vim.fn.pumvisible() == 1 and has_compe then
    return vim.fn['compe#close']()
  else
    return rhs('<CR>')
  end
end

local shift_tab = function()
  if vim.fn.pumvisible() == 1 then
    return rhs('<C-p>')
  elseif has_luasnip and luasnip.jumpable(-1) then
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
--
-- If `feedkeys` is true, then the resulting key presses will be sent via
-- `nvim_feedkeys()`, otherwise they will just be returned as a string.
local smart_tab = function(opts)
  local feedkeys = (opts or {}).feedkeys
  local keys = nil
  if vim.o.expandtab then
    keys = '<Tab>' -- Neovim will insert spaces.
  else
    local col = vim.fn.col('.')
    local line = vim.api.nvim_get_current_line()
    local prefix = line:sub(1, col)
    local in_leading_indent = prefix:find('^%s*$')
    if in_leading_indent then
      keys = '<Tab>' -- Neovim will insert a hard tab.
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
      keys = (' '):rep(move)
    end
  end
  if feedkeys then
    vim.api.nvim_feedkeys(rhs(keys), 'nt', true)
  else
    return rhs(keys)
  end
end

local pending_completion = false

local complete = function()
  -- We want to send smart_tab() here if there is no completion available,
  -- but `compe#complete()` is async, so we don't know yet. Instead, we
  -- set a flag that we'll be checking from our `CompleteChanged` and
  -- `CompleteDonePre` autocommands later on.
  pending_completion = true
  if has_compe then
    vim.fn['compe#complete']()
  end
end

local tab = function()
  if vim.fn.pumvisible() == 1 then
    if vim.fn.pum_getpos().size == 1 and has_compe then
      -- There is only one completion and it is selected. Complete it.
      return vim.fn['compe#confirm']()
    else
      return rhs('<C-n>')
    end
  elseif has_luasnip and luasnip.expand_or_jumpable() then
    return rhs('<Plug>luasnip-expand-or-jump')
  elseif in_whitespace() then
    return smart_tab()
  else
    complete()
    return rhs('<Ignore>')
  end
end

local handle_complete_changed = function ()
  if pending_completion then
    local info = vim.fn.complete_info()
    if info.pum_visible == 0 then
      smart_tab({feedkeys = true})
    end
    pending_completion = false
  end
end

local handle_complete_done_pre = function ()
  if pending_completion then
    local info = vim.fn.complete_info()
    if info.pum_visible == 0 then
      smart_tab({feedkeys = true})
    end
    pending_completion = false
  end
end

-- TODO: in the end I didn't need this trick, but may still want to move this
-- somewhere generic.
-- local is_idle = function return vim.fn.getchar(1) ~= 0 end

augroup('WincentAutocomplete', function ()
  autocmd('CompleteChanged', '*', handle_complete_changed)
  autocmd('CompleteDonePre', '*', handle_complete_done_pre)
end)

imap('<S-Tab>', shift_tab, {expr = true, silent = true})
imap('<Tab>', tab, {expr = true, silent = true})
inoremap('<BS>', smart_bs, {expr = true})
inoremap('<C-e>', c_e, {expr = true, silent = true})
inoremap('<C-j>', 'pumvisible() ? "\\<C-n>" : "\\<C-j>"', {expr = true})
inoremap('<C-k>', 'pumvisible() ? "\\<C-p>" : "\\<C-k>"', {expr = true})
inoremap('<C-y>', c_y, {expr = true, silent = true})
inoremap('<CR>', cr, {expr = true, silent = true})
inoremap('<Down>', 'pumvisible() ? "\\<C-n>" : "\\<Down>"', {expr = true})
inoremap('<Up>', 'pumvisible() ? "\\<C-p>" : "\\<Up>"', {expr = true})

-- TODO: decide whether we should be duplicating most of our i-mappings as
-- s-mappings too.
smap('<S-Tab>', shift_tab, {expr = true, silent = true})
smap('<Tab>', tab, {expr = true, silent = true})
snoremap('<C-e>', c_e, {expr = true, silent = true})
snoremap('<CR>', cr, {expr = true, silent = true})
