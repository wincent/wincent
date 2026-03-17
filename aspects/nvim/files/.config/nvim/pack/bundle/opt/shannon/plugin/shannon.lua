local shannon = require('shannon')

vim.api.nvim_create_user_command('Shannon', function(opts)
  local file = vim.fn.expand('%:.')
  local line_start, line_end

  if opts.range == 2 then
    line_start = opts.line1
    line_end = opts.line2
  else
    line_start = vim.fn.line('.')
    line_end = line_start
  end

  local context = {
    file = file,
    line_start = line_start,
    line_end = line_end,
  }

  local visual_mode = opts.range == 2 and vim.fn.visualmode() or nil

  if visual_mode == 'v' then
    local start_col = vim.fn.getpos("'<")[3]
    local end_col = vim.fn.getpos("'>")[3]
    local lines = vim.api.nvim_buf_get_lines(0, line_start - 1, line_end, false)
    if #lines == 1 then
      lines[1] = lines[1]:sub(start_col, end_col)
    else
      lines[1] = lines[1]:sub(start_col)
      lines[#lines] = lines[#lines]:sub(1, end_col)
    end
    context.lines = lines
    context.col_start = start_col
    context.col_end = end_col
  elseif visual_mode == '\22' then
    local start_col = vim.fn.getpos("'<")[3]
    local end_col = vim.fn.getpos("'>")[3]
    local lines = vim.api.nvim_buf_get_lines(0, line_start - 1, line_end, false)
    for i, line in ipairs(lines) do
      lines[i] = line:sub(start_col, end_col)
    end
    context.lines = lines
    context.col_start = start_col
    context.col_end = end_col
  end

  shannon.open(context)
end, { range = true })

vim.keymap.set('n', '<LocalLeader>s', ':Shannon<CR>', { silent = true })
vim.keymap.set('v', '<LocalLeader>s', ':Shannon<CR>', { silent = true })
