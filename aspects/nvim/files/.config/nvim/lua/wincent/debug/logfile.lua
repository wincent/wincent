--- Returns the absolute path of the log file used by `wincent.debug.log()` and
--- `wincent.debug.autocmds()`.
---
--- The name embeds the date, the time, and the PID, which makes it unique among
--- concurrently running instances (thanks to the PID), unique across instances
--- separated in time (thanks to the timestamp, because PIDs get recycled), and
--- chronologically sortable.
---
--- The path is resolved relative to the current working directory the first
--- time it is needed, and then cached, because:
---
--- - Appending across many calls is the whole point, so the name must not be
---   regenerated per call.
--- - The working directory can change mid-session (`:cd`, `:lcd`, `:tcd`), and
---   we don't want subsequent writes to silently land somewhere else.
---
--- The cache lives in `wincent.g` rather than in a module-local so that it
--- survives the reloading that this file is likely to be subjected to during a
--- debugging session.
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
