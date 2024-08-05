local is_floating = function()
  local current_window = vim.api.nvim_get_current_win()
  local config = vim.api.nvim_win_get_config(current_window)
  return config.relative ~= ''
end

local current_window = 0

local get_margins = function()
  local screen_height = vim.o.lines
  local screen_width = vim.o.columns
  local window_height = vim.api.nvim_win_get_height(current_window)
  local window_width = vim.api.nvim_win_get_width(current_window)
  local window_position = vim.api.nvim_win_get_position(current_window)
  local cmdheight = vim.o.cmdheight
  local statusline = 1

  return {
    top = window_position[1],
    right = screen_width - window_position[2] - window_width,
    left = window_position[2],
    bottom = screen_height - window_position[1] - window_height - cmdheight - statusline,
  }
end

local is_on_edge = function(side)
  local margins = get_margins()
  if side == 'top' then
    return margins.top == 0
  elseif side == 'right' then
    return margins.right == 0
  elseif side == 'bottom' then
    return margins.bottom == 0
  elseif side == 'left' then
    return margins.left == 0
  end
end

local is_only_window = function(axis)
  local margins = get_margins()
  if axis == 'vertical' then
    return margins.top == 0 and margins.bottom == 0
  elseif axis == 'horizontal' then
    return margins.right == 0 and margins.left == 0
  end
end

local resize = function(action, axis)
  local keys = ''
  if action == 'grow' then
    if axis == 'horizontal' then
      keys = '<C-W>5>'
    elseif axis == 'vertical' then
      keys = '<C-W>5+'
    end
  elseif action == 'shrink' then
    if axis == 'horizontal' then
      keys = '<C-W>5<'
    elseif axis == 'vertical' then
      keys = '<C-W>5-'
    end
  end
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', false)
end

local should_resize = function(axis)
  return not is_floating() and not is_only_window(axis)
end

local normal = {
  -- Move split down.
  resize_down = function()
    if should_resize('vertical') then
      if is_on_edge('bottom') then
        resize('shrink', 'vertical')
      elseif is_on_edge('top') then
        resize('grow', 'vertical')
      else -- Is in middle.
        resize('grow', 'vertical')
      end
    end
  end,

  -- Move split left.
  resize_left = function()
    if should_resize('horizontal') then
      if is_on_edge('left') then
        resize('shrink', 'horizontal')
      elseif is_on_edge('right') then
        resize('grow', 'horizontal')
      else -- Is in middle.
        resize('shrink', 'horizontal')
      end
    end
  end,

  -- Move split right.
  resize_right = function()
    if should_resize('horizontal') then
      if is_on_edge('right') then
        resize('shrink', 'horizontal')
      elseif is_on_edge('left') then
        resize('grow', 'horizontal')
      else -- In in middle.
        resize('grow', 'horizontal')
      end
    end
  end,

  -- Move split up.
  resize_up = function()
    if should_resize('vertical') then
      if is_on_edge('top') then
        resize('shrink', 'vertical')
      elseif is_on_edge('bottom') then
        resize('grow', 'vertical')
      else -- Is in middle.
        resize('shrink', 'vertical')
      end
    end
  end,
}

return normal
