--- Tests the compiler plugin in the current buffer (see
--- `:help write-compiler-plugin`) by sourcing it and then feeding the sample
--- output at the bottom of the file through the 'errorformat' that it just set.
local function compiler()
  local name = vim.api.nvim_buf_get_name(0)

  if vim.fs.basename(vim.fs.dirname(name)) ~= 'compiler' then
    vim.notify('wincent.debug.compiler: not editing a file in a "compiler" directory', vim.log.levels.ERROR)
    return
  end

  vim.cmd.source('%')

  -- Sample output starts after the point at which execution stops: `:finish` in
  -- a Vimscript compiler plugin, or the start of a trailing long comment in a
  -- Lua one.
  local pattern = name:match('%.lua$') and [[^--\[=*\[]] or [[^finish\>]]

  local line = vim.fn.search(pattern, 'nw')

  if line == 0 then
    vim.notify('wincent.debug.compiler: could not find start of sample output', vim.log.levels.ERROR)
    return
  end

  vim.fn.setqflist({})
  vim.cmd((line + 1) .. ',$cgetbuffer')
  vim.cmd.copen()
end

return compiler
