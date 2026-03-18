return function()
  local ns = vim.api.nvim_create_namespace('shannon')
  local marks = vim.api.nvim_buf_get_extmarks(0, ns, 0, -1, {})
  if #marks == 0 then
    vim.api.nvim_echo({ { 'shannon: no marks in buffer', 'WarningMsg' } }, true, {})
    return
  end

  local row = vim.api.nvim_win_get_cursor(0)[1] - 1

  for i = #marks, 1, -1 do
    if marks[i][2] < row then
      vim.api.nvim_win_set_cursor(0, { marks[i][2] + 1, 0 })
      return
    end
  end

  local last = marks[#marks]
  vim.api.nvim_win_set_cursor(0, { last[2] + 1, 0 })
end
