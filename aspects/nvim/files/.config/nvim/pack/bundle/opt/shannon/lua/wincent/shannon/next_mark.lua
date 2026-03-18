return function()
  local ns = vim.api.nvim_create_namespace('shannon')
  local marks = vim.api.nvim_buf_get_extmarks(0, ns, 0, -1, {})
  if #marks == 0 then
    vim.api.nvim_echo({ { 'shannon: no marks in buffer', 'WarningMsg' } }, true, {})
    return
  end

  local row = vim.api.nvim_win_get_cursor(0)[1] - 1

  for _, mark in ipairs(marks) do
    if mark[2] > row then
      vim.api.nvim_win_set_cursor(0, { mark[2] + 1, 0 })
      return
    end
  end

  vim.api.nvim_win_set_cursor(0, { marks[1][2] + 1, 0 })
end
