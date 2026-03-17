local M = {}

local config = {
  tmux_pane = nil,
}

function M.setup(opts)
  if opts then
    config = vim.tbl_extend('force', config, opts)
  end
end

local function find_claude_pane()
  local current_pane = vim.env.TMUX_PANE
  if not current_pane then
    return nil
  end

  local pane_pids = {}
  local pane_output = vim.fn.system("tmux list-panes -F '#{pane_id} #{pane_pid}'")
  for pane_id, pane_pid in pane_output:gmatch('(%%[%d]+)%s+(%d+)') do
    if pane_id ~= current_pane then
      pane_pids[tonumber(pane_pid)] = pane_id
    end
  end

  local claude_pids = vim.fn.system('pgrep claude')
  for pid_str in claude_pids:gmatch('%d+') do
    local pid = pid_str
    for _ = 1, 10 do
      local ppid = vim.trim(vim.fn.system('ps -p ' .. pid .. ' -o ppid='))
      if ppid == '' or ppid == '1' then
        break
      end
      local ppid_num = tonumber(ppid)
      if ppid_num and pane_pids[ppid_num] then
        return pane_pids[ppid_num]
      end
      pid = ppid
    end
  end

  return nil
end

function M.get_pane()
  if config.tmux_pane then
    return config.tmux_pane
  end
  return find_claude_pane()
end

function M.open(context)
  local parent_win = vim.api.nvim_get_current_win()

  local height = 8
  local width = math.floor(vim.o.columns * 0.6)
  local float_col = math.floor((vim.o.columns - width) / 2)

  local screen_pos = vim.fn.screenpos(0, context.line_end, 1)
  local float_row
  if screen_pos.row == 0 then
    float_row = math.floor((vim.o.lines - height) / 2)
  else
    float_row = screen_pos.row
    if float_row + height + 2 > vim.o.lines then
      local start_pos = vim.fn.screenpos(0, context.line_start, 1)
      float_row = (start_pos.row > 0 and start_pos.row or screen_pos.row) - height - 2
      if float_row < 0 then
        float_row = 0
      end
    end
  end

  local buf = vim.api.nvim_create_buf(false, true)

  local title
  if context.line_start == context.line_end then
    title = string.format(' %s:%d ', context.file, context.line_start)
  else
    title = string.format(' %s:%d-%d ', context.file, context.line_start, context.line_end)
  end

  local _win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = width,
    height = height,
    row = float_row,
    col = float_col,
    style = 'minimal',
    border = 'rounded',
    title = title,
    title_pos = 'center',
  })

  vim.api.nvim_set_option_value('buftype', 'acwrite', { buf = buf })
  vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = buf })
  vim.api.nvim_set_option_value('filetype', 'markdown', { buf = buf })
  vim.api.nvim_buf_set_name(buf, 'shannon://prompt')

  vim.cmd('startinsert')

  vim.api.nvim_create_autocmd('BufWriteCmd', {
    buffer = buf,
    callback = function()
      local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      local text = table.concat(lines, '\n')
      if vim.trim(text) ~= '' then
        M.send(context, text)
      end
      vim.api.nvim_set_option_value('modified', false, { buf = buf })
    end,
  })

  vim.keymap.set({ 'n', 'i' }, '<C-y>', function()
    local view = vim.api.nvim_win_call(parent_win, function()
      return vim.fn.winsaveview()
    end)
    if view.topline > 1 then
      view.topline = view.topline - 1
      vim.api.nvim_win_call(parent_win, function()
        vim.fn.winrestview(view)
      end)
    end
  end, { buffer = buf })

  vim.keymap.set({ 'n', 'i' }, '<C-e>', function()
    local view = vim.api.nvim_win_call(parent_win, function()
      return vim.fn.winsaveview()
    end)
    view.topline = view.topline + 1
    vim.api.nvim_win_call(parent_win, function()
      vim.fn.winrestview(view)
    end)
  end, { buffer = buf })
end

function M.send(context, text)
  local location
  if context.col_start and context.col_end then
    if context.line_start == context.line_end then
      location = string.format(
        '%s:%d:%d-%d',
        context.file, context.line_start, context.col_start, context.col_end
      )
    else
      location = string.format(
        '%s:%d:%d-%d:%d',
        context.file, context.line_start, context.col_start, context.line_end, context.col_end
      )
    end
  elseif context.line_start == context.line_end then
    location = string.format('%s:%d', context.file, context.line_start)
  else
    location = string.format('%s:%d-%d', context.file, context.line_start, context.line_end)
  end

  local context_line
  if context.lines then
    local snippet = table.concat(context.lines, '\n')
    context_line = string.format('Context: %s: %s', location, snippet)
  else
    context_line = string.format('Context: %s', location)
  end

  local prompt
  if text:match('^/btw') then
    prompt = string.format('%s\n\n%s', text, context_line)
  else
    prompt = string.format('%s\n\n%s', context_line, text)
  end

  local tmpfile = os.tmpname()
  local f = io.open(tmpfile, 'w')
  if not f then
    vim.api.nvim_err_writeln('shannon: failed to open temp file')
    return
  end
  f:write(prompt)
  f:close()

  local pane = M.get_pane()
  if not pane then
    vim.api.nvim_err_writeln('shannon: no Claude session found in tmux')
    os.remove(tmpfile)
    return
  end
  vim.fn.system({ 'tmux', 'load-buffer', tmpfile })
  vim.fn.system({ 'tmux', 'paste-buffer', '-t', pane })
  vim.fn.system({ 'tmux', 'send-keys', '-t', pane, 'Enter' })
  os.remove(tmpfile)
end

return M
