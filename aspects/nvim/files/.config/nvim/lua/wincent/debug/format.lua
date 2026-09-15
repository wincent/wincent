--- Turns arbitrary values into a flat list of single-line strings suitable for
--- passing to `vim.fn.writefile()` or `vim.api.nvim_echo()`.
---
--- Note that splitting on newlines is not merely cosmetic: `writefile()`
--- replaces any newline _within_ a list item with a NUL byte, so multi-line
--- strings (such as those produced by `vim.inspect()`) have to be split up
--- ahead of time in order to produce a readable log.
---
--- @param ... any
--- @return string[]
local function format(...)
  local lines = {}

  local function append(str)
    vim.list_extend(lines, vim.split(str, '\n', { plain = true }))
  end

  for i = 1, select('#', ...) do
    local value = select(i, ...)
    if type(value) == 'string' then
      append(value)
    elseif type(value) == 'table' and vim.islist(value) then
      vim.list_extend(lines, format(unpack(value)))
    else
      append(vim.inspect(value))
    end
  end

  return lines
end

return format
