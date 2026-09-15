--- Typechecks the current project.
local function typecheck()
  -- Make subsequent `:make` work (eg. invoked by Dispatch's `m<CR>` mapping).
  vim.cmd.compiler('tsc')

  -- Do an immediate Make.
  vim.cmd.Make()
end

return typecheck
