wincent.g.command_callbacks = {}

-- TODO: garbage-collect overwritten command callbacks

-- Wrapper for simple :command use cases. `repl` (replacement) may be a string
-- or a Lua function.
--
-- Slight departure from Vim default behavior: `force = true` is the default
-- (ie. `:command!` instead of `:command`), seeing as I am using that at
-- literally every call-site.
--
local command = function(name, repl, opts)
  opts = opts or {}
  local repl_type = type(repl)
  if repl_type == 'function' then
    local key = wincent.util.get_key_for_fn(repl, wincent.g.command_callbacks)
    wincent.g.command_callbacks[key] = repl
    repl = 'lua wincent.g.command_callbacks.' .. key .. '()'
  elseif repl_type ~= 'string' then
    error('command(): unsupported repl type: ' .. repl_type)
  end
  local prefix = opts.force == false and 'command' or 'command!'
  if opts.bang then
    prefix = prefix .. ' -bang'
  end
  if opts.complete then
    prefix = prefix .. ' -complete=' .. opts.complete
  end
  if opts.nargs then
    prefix = prefix .. ' -nargs=' .. opts.nargs
  end
  if opts.range then
    prefix = prefix .. ' -range'
  end
  vim.cmd(prefix .. ' ' .. name .. ' ' .. repl)
end

return command
