-- This is a custom foldexpr (see `:help 'foldexpr'`) that combines the best of
-- `:set foldmethod=indent` and `:set foldmethod=marker`:
--
-- - If on an indented line, behaves like `foldmethod=indent`.
-- - If on a non-indented line, behaves like `foldmethod=marker`.
--
-- For the meaning of the return values, see `:help fold-expr`.
--
-- To debug this, set these to show the fold level in the gutter:
--
--    :set statuscolumn=%l\ %{foldlevel(v:lnum)}
--    :set numberwidth=6
--
local foldexpr = function(line_number)
  local current_indent = vim.fn.indent(line_number)
  local line = vim.fn.getline(line_number)

  -- Deal with fold markers first.
  local start_level = line:match('{{{(%d+)')
  local end_level = line:match('}}}(%d+)')
  if start_level ~= nil then
    -- A fold with level `1`, `2`, ... `N` starts at this line.
    return '>' .. start_level
  elseif end_level ~= nil then
    -- A fold with level `1`, `2`, ... `N` ends at this line.
    return '<' .. end_level
  elseif line:match('{{{') then
    -- Add 1 to the fold level of the previous line, use the result for the
    -- current line.
    return 'a1'
  elseif line:match('}}}') then
    -- Subtract 1 from the fold level of the previous line; use the result for
    -- the next line.
    return 's1'
  else
    -- Do indent-based folding.
    local previous_non_blank = vim.fn.prevnonblank(line_number - 1)
    local previous_indent = line_number > 1 and vim.fn.indent(line_number - 1) or 0
    local line_count = vim.api.nvim_buf_line_count(0)
    local next_indent = line_number < line_count and vim.fn.indent(line_number + 1) or 0
    local next_non_blank_indent = vim.fn.indent(vim.fn.nextnonblank(line_number + 1))
    local has_indented = previous_non_blank == line_number - 1 and current_indent > previous_indent
    local will_dedent = current_indent > next_non_blank_indent
    if previous_indent == next_indent then
      -- Special case: there's a single line with equal indents above and below
      -- it.
      return '='
    elseif has_indented then
      return 'a' .. math.floor((current_indent - previous_indent) / vim.fn.shiftwidth())
    elseif will_dedent then
      return 's' .. math.floor((current_indent - next_non_blank_indent) / vim.fn.shiftwidth())
    else
      -- Line has same fold level as previous line.
      return '='
    end
  end
end

return foldexpr
