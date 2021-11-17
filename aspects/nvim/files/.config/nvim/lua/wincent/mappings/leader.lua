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

local jump = function(mapping, delta)
  -- Calculate the number of steps to move up or down through the jump list in
  -- order to get to a new bufnr (we use bufnr because not all entries will have a
  -- filename).
  local count = 0
  local jumplist, idx = unpack(vim.fn.getjumplist())
  local previous_entry = jumplist[idx]
  local next_idx = idx + delta
  while next_idx > 0 and next_idx < #jumplist do
    count = count + 1
    local next_entry = jumplist[next_idx]
    if next_entry.bufnr ~= previous_entry.bufnr then
      -- We found the next file; we're done.
      local key =  vim.api.nvim_replace_termcodes(mapping, true, false, true)
      vim.api.nvim_feedkeys(count .. key, 'n', true)
      vim.cmd('echo') -- Clear any previous "No more jumps!" message.
      return
    else
      previous_entry = next_entry
      next_idx = next_idx + delta
    end
  end
  vim.api.nvim_err_writeln('No more jumps!')
end

local jump_in_file = function ()
  jump('<C-i>', 1)
end

local jump_out_file = function ()
  jump('<C-o>', -1)
end

-- TODO: split into files
leader.cycle_numbering = cycle_numbering
leader.get_highlight_group = get_highlight_group
leader.jump_in_file = jump_in_file
leader.jump_out_file = jump_out_file
leader.number_flag = number_flag

return leader
