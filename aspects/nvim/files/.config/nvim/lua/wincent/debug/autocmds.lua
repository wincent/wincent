local logfile = require('wincent.debug.logfile')

local group_name = 'wincent.debug.autocmds'

local events = {
  'BufAdd',
  'BufDelete',
  'BufEnter',
  'BufFilePost',
  'BufHidden',
  'BufLeave',
  'BufNew',
  'BufNewFile',
  'BufRead',
  'BufReadPost',
  'BufReadPre',
  'BufUnload',
  'BufWinEnter',
  'BufWinLeave',
  'BufWipeout',
  'BufWrite',
  'BufWritePost',
  'BufWritePre',
  'CursorHold',
  'CursorHoldI',
  'CursorMoved',
  'CursorMovedI',
  'FileType',
  'FocusGained',
  'FocusLost',
  'InsertEnter',
  'InsertLeave',
  'QuitPre',
  'TabClosed',
  'TabEnter',
  'TabLeave',
  'TabNew',
  'TabNewEntered',
  'TextYankPost',
  'VimEnter',
  'VimLeave',
  'VimLeavePre',
  'VimResized',
  'WinClosed',
  'WinEnter',
  'WinLeave',
  'WinNew',
}

--- Logs a large selection of autocommand events, along with the buffer, window
--- and filetype context in which they fire.
---
--- In theory you can do this with 'verbose' (>= 9) and 'verbosefile', but this
--- one is a bit more specialized.
---
--- Calling this again replaces the previously registered autocommands. To turn
--- logging back off:
---
---     :lua vim.api.nvim_del_augroup_by_name('wincent.debug.autocmds')
---
--- @param path? string Where to log (defaults to `wincent.debug.logfile()`).
local function autocmds(path)
  local log

  if path == nil then
    -- Announces itself on first use.
    log = logfile()
  else
    log = vim.fn.fnamemodify(path, ':p')
    vim.notify(group_name .. ': logging to ' .. log)
  end

  local group = vim.api.nvim_create_augroup(group_name, { clear = true })

  vim.api.nvim_create_autocmd(events, {
    group = group,
    pattern = '*',
    callback = function(args)
      local amatch = vim.fn.fnamemodify(args.match, ':t')

      local afile = vim.fn.fnamemodify(args.file, ':t')
      if afile == '' then
        afile = '...'
      end

      local bufnr = vim.api.nvim_get_current_buf()
      local bufnr_description = bufnr == args.buf and tostring(bufnr) or (bufnr .. ' [' .. args.buf .. ']')

      local bufname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ':t')
      if bufname == '' then
        bufname = '...'
      end
      local bufname_description = bufname == afile and bufname or (bufname .. '/' .. afile)

      local line = table.concat({
        os.date('%H:%M:%S'),
        args.event,
        '<amatch>=' .. amatch,
        bufname_description,
        '(b:' .. bufnr_description .. ', w:' .. vim.fn.winnr() .. ', ft=' .. vim.bo.filetype .. ')',
      }, ' ')

      vim.fn.writefile({ line }, log, 'as')
    end,
  })
end

return autocmds
