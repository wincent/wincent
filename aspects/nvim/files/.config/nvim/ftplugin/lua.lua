-- Set options to open require with gf

vim.opt_local.include = vim.trim([[
  \v<((do|load)file|require)\s*\(?['"]\zs[^'"]+\ze['"]
]])

vim.opt_local.includeexpr = 'v:lua.wincent.ftplugin.lua.includeexpr(v:fname)'
