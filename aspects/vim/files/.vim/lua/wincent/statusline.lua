local util = require'wincent.util'

local statusline = {}

local update_statusline = function(default, action)
  local result
  local filetype = vim.bo.filetype

  if filetype == 'command-t' then
    -- Will use Command-T-provided buffer name, but need to escape spaces.
    result = '\\ \\ ' .. vim.api.nvim_buf_get_name(0):gsub(' ', '\\ ')
  elseif filetype == 'diff' and
    util.tabpage_get_var(0, 'diffpanel') ~= nil and
    util.tabpage_get_var(0, 'diffpanel') == vim.api.nvim_buf_get_name(0):gsub(' ', '\\ ') then
    -- Less ugly, and nothing really useful to show.
    result = 'Undotree\\ preview'
  elseif filetype == 'undotree' then
    -- Don't override; undotree does its own thing.
    result =  0
  elseif filetype == 'qf' then
    if action == 'blur' then
      result =
            '%{luaeval("' .. "require'wincent.statusline'.gutterpadding()" .. '")}'
            .. ' '
            .. ' '
            .. ' '
            .. ' '
            .. '%<'
            .. '%q'
            .. ' '
            .. '%{get(w:,"quickfix_title","")}'
            .. '%='
    else
      result = util.get_var('WincentQuickfixStatusline') or ''
    end
  else
    result = 1
  end

  if result == 0 then
    -- Do nothing.
  elseif result == 1 then
    vim.api.nvim_win_set_option(0, 'statusline', default)
  else
    -- Apply custom statusline.
    vim.api.nvim_win_set_option(0, 'statusline', result)
  end
end

statusline.blur_statusline = function()
  -- Default blurred statusline (buffer number: filename).
  local blurred='%{luaeval("' .. "require'wincent.statusline'.gutterpadding()" .. '")}'
  blurred = blurred .. ' ' -- space
  blurred = blurred .. ' ' -- space
  blurred = blurred .. ' ' -- space
  blurred = blurred .. ' ' -- space
  blurred = blurred .. '%<' -- truncation point
  blurred = blurred .. '%f' -- filename
  blurred = blurred .. '%=' -- split left/right halves (makes background cover whole)
  update_statusline(blurred, 'blur')
end

statusline.focus_statusline = function()
  -- `setlocal statusline=` will revert to global 'statusline' setting.
  update_statusline('', 'focus')
end

statusline.gutterpadding = function()
  local signcolumn = 0
  local option = vim.wo.signcolumn
  if option == 'yes' then
    signcolumn = 2
  elseif option == 'auto' then
    local signs = vim.fn.sign_getplaced('')
    if #signs[1].signs > 0 then
      signcolumn = 2
    end
  end

  local minwidth = 2
  local numberwidth = vim.wo.numberwidth
  local row = vim.api.nvim_buf_line_count(0)
  local gutterwidth = math.max(unpack({
      (tostring(row):len() + 1),
      minwidth,
      numberwidth,
  })) + signcolumn
  local padding = (' '):rep(gutterwidth - 1)
  return padding
end

statusline.lhs = function()
  local padding = statusline.gutterpadding()

  if vim.bo.modified then
    -- HEAVY BALLOT X - Unicode: U+2718, UTF-8: E2 9C 98
    return padding .. '✘ '
  else
    return padding .. '  '
  end
end

return statusline
