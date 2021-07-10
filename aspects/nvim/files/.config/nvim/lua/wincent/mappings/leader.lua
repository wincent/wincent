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

leader.cycle_numbering = cycle_numbering
leader.number_flag = number_flag

return leader
