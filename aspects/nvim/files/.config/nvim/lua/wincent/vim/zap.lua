-- Removes trailing whitespace from current buffer.
local zap = function()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
  for i, line in ipairs(lines) do
    local zapped = line:gsub('(.-)%s*$', '%1')
    if zapped ~= line then
      vim.api.nvim_buf_set_lines(0, i - 1, i, true, { zapped })
    end
  end
end

return zap
