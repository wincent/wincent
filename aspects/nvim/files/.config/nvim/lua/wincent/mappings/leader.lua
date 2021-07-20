local leader = {}

local number_flag = 'wincent_number'

local cycle_numbering = function()
  local relativenumber = vim.wo.relativenumber
  local number = vim.wo.number

  -- Cycle through:
  -- - relativenumber + number
  -- - number (only)
  -- - no numbering
  if (vim.deep_equal({relativenumber, number}, {true, true})) then
    relativenumber, number = false, true
  elseif (vim.deep_equal({relativenumber, number}, {false, true})) then
    relativenumber, number = false, false
  elseif (vim.deep_equal({relativenumber, number}, {false, false})) then
    relativenumber, number = true, true
  elseif (vim.deep_equal({relativenumber, number}, {true, false})) then
    relativenumber, number = false, true
  end

  vim.wo.relativenumber = relativenumber
  vim.wo.number = number

  -- Leave a mark so that other functions can check to see if the user has
  -- overridden the settings for this window.
  vim.w[number_flag] = true
end

-- Based on: http://vim.wikia.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor
local get_highlight_group = function()
  local pos = vim.api.nvim_win_get_cursor(0)
  local line = pos[1]
  local col = pos[2]
  local synID = vim.fn.synID
  local synIDattr = vim.fn.synIDattr
  local synIDtrans = vim.fn.synIDtrans
  return (
    'hi<' ..
    synIDattr(synID(line, col, true), 'name') ..
    '> trans<' ..
    synIDattr(synID(line, col, false), 'name') ..
    '> lo<' ..
    synIDattr(synIDtrans(synID(line, col, true)), 'name') ..
    '>'
  )
end

-- TODO: split into files
leader.cycle_numbering = cycle_numbering
leader.get_highlight_group = get_highlight_group
leader.number_flag = number_flag

return leader
