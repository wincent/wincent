-- Wrapper for simple `:command` use cases. `repl` (replacement) may be a string
-- or a Lua function.
--
-- Slight departure from Vim default behavior: `force = true` is the default
-- (ie. this is equvialent to `:command!` instead of `:command`), seeing as I am
-- using that at literally every call-site.
--
local command = function(name, repl, opts)
  opts = opts or {}
  local repl_type = type(repl)
  if repl_type == 'function' then
    -- No need to pass `force = true` here because that is the default.
    vim.api.nvim_create_user_command(name, repl, opts)
  elseif repl_type ~= 'string' then
    error('command(): unsupported repl type: ' .. repl_type)
  else
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
end

return command
