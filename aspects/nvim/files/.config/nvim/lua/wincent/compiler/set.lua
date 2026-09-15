--- @class CompilerOptions
--- @field makeprg string
--- @field errorformat string[] One 'errorformat' item per entry, written in
---        plain form (ie. `[[%\s%#%l:%c]]`, not the doubly-escaped
---        `%\\s%#%l:%c` that a literal `:set` command would require).

--- Applies compiler settings from a Lua compiler plugin (see
--- `:help write-compiler-plugin`).
---
--- We route through `:CompilerSet` rather than assigning to `vim.bo` or
--- `vim.opt_local` because that is what preserves the distinction between
--- `:compiler` (buffer-local) and `:compiler!` (global); `:compiler` defines
--- `:CompilerSet` as an alias for either `:setlocal` or `:set` accordingly.
---
--- When sourced outside of `:compiler` (eg. by `wincent.debug.compiler()`) that
--- command doesn't exist, so we temporarily supply a `:setlocal` version of it,
--- mirroring the guard that Vim's own compiler plugins use.
---
--- @param options CompilerOptions
local function set(options)
  local temporary = vim.fn.exists(':CompilerSet') ~= 2

  if temporary then
    vim.api.nvim_create_user_command('CompilerSet', function(opts)
      vim.cmd('setlocal ' .. opts.args)
    end, { nargs = '*' })
  end

  -- `:set` needs backslashes, spaces, pipes and quotes escaped. Doing that here
  -- means the option values above can be written in readable form.
  local function escape(value)
    return vim.fn.escape(value, ' \\|"')
  end

  vim.cmd('CompilerSet makeprg=' .. escape(options.makeprg))
  vim.cmd('CompilerSet errorformat=' .. escape(table.concat(options.errorformat, ',')))

  if temporary then
    vim.api.nvim_del_user_command('CompilerSet')
  end
end

return set
