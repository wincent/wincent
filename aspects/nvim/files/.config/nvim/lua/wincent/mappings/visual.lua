local is_visual = function ()
  -- vim.api.nvim_get_mode().mode is always "n", so using this instead:
  return vim.fn.visualmode() == 'V'
end

local move = function(address, should_move)
  if is_visual() and should_move then
    vim.cmd("'<,'>move " .. address)
    vim.api.nvim_feedkeys('gv=', 'n', true)
  end
  vim.api.nvim_feedkeys('gv', 'n', true)
end

local visual = {
  move_down = function (lastline)
    local count = vim.v.count == 0 and 1 or vim.v.count
    local max = vim.fn.line('$') - lastline
    local movement = vim.fn.min({count, max})
    local address = "'>+" .. movement
    local should_move = movement > 0
    move(address, should_move)
  end,

  move_up = function (firstline)
    local count = vim.v.count == 0 and -1 or -vim.v.count
    local max = (firstline - 1) * -1
    local movement = vim.fn.max({count, max})
    local address = "'<" .. (movement - 1)
    local should_move = movement < 0
    move(address, should_move)
  end,
}

return visual
