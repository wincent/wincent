--- Returns the absolute path of the log file used by `wincent.debug.log()` and
--- `wincent.debug.autocmds()`.
---
--- The name embeds the date, the time, and the PID, which makes it (very
--- likely) unique among instances and chronologically sortable.
---
--- The path is resolved relative to the current working directory the first
--- time it is needed, and then cached, because we don't want multiple log files
--- being created if we `:cd`, `:lcd`, `:tcd` etc.
---
--- @return string
local function logfile()
  if wincent.g.debug_logfile == nil then
    local name = 'wincent-nvim-' .. os.date('%Y%m%d-%H%M%S') .. '-' .. vim.uv.os_getpid() .. '.txt'

    wincent.g.debug_logfile = vim.fn.fnamemodify(name, ':p')

    vim.notify('wincent.debug: logging to ' .. wincent.g.debug_logfile)
  end

  return wincent.g.debug_logfile
end

return logfile
