local number_flag = 'wincent.numbering'

--- @class cycle_numbering
--- @field flag string
--- @operator call:nil
local cycle_numbering = {
  __call = function()
    local relativenumber = vim.wo.relativenumber
    local number = vim.wo.number

    -- Cycle through:
    -- - relativenumber + number
    -- - number (only)
    -- - no numbering
    if vim.deep_equal({ relativenumber, number }, { true, true }) then
      relativenumber, number = false, true
    elseif vim.deep_equal({ relativenumber, number }, { false, true }) then
      relativenumber, number = false, false
    elseif vim.deep_equal({ relativenumber, number }, { false, false }) then
      relativenumber, number = true, true
    elseif vim.deep_equal({ relativenumber, number }, { true, false }) then
      relativenumber, number = false, true
    end

    vim.wo.relativenumber = relativenumber
    vim.wo.number = number

    -- Leave a mark so that other functions can check to see if the user has
    -- overridden the settings for this window.
    vim.w[number_flag] = true
  end,

  flag = number_flag,
}

setmetatable(cycle_numbering, {
  __call = cycle_numbering.__call,
})

return cycle_numbering
