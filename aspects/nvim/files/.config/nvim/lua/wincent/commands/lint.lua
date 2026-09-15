--- Lints the current project.
local function lint()
  -- TODO: make this smart about which compiler plug-in to use based on location

  -- Make subsequent `:make` work (eg. invoked by Dispatch's `m<CR>` mapping).
  vim.cmd.compiler('eslint')

  -- Do an immediate Make.
  vim.cmd.Make()
end

return lint
