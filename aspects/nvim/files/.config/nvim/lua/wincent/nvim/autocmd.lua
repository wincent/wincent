--- @alias AutocmdOptions {
---   group?: string,
---   once?: boolean,
--- }
---
--- Defines an autocmd identified by `name`, matching `pattern`.
---
--- @alias AutocmdCallback fun(
---   name: string,
---   pattern: string,
---   cmd?: string | (fun(): nil),
---   opts?: AutocmdOptions,
--- )

--- `nvim_create_autocmd()` wrapper for simple use cases.
---
--- If `name` contains a comma-separated list, it is split into a Lua list.
---
--- `cmd` may be a string containing an EX command (see `:h Ex-commands`) or a
--- Lua function.
---
--- @param name string
--- @param pattern string
--- @param cmd? string | (fun(): nil)
--- @param opts? AutocmdOptions
local function autocmd(name, pattern, cmd, opts)
  opts = opts or {}
  local events = vim.split(vim.trim(name), ',')
  vim.api.nvim_create_autocmd(events, {
    callback = type(cmd) == 'function' and cmd or nil,
    command = type(cmd) == 'string' and cmd or nil,
    group = opts.group,
    once = not not opts.once,
    pattern = pattern,
  })
end

return autocmd
