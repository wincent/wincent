-- Cleaner/simpler clone of the built-in tabline, but without the window
-- counts, the modified flag, or the close widget.
local render = function ()
  local line = ''
  local current = vim.api.nvim_tabpage_get_number(0)

  for i = 1, vim.fn.tabpagenr('$') do
    if i == current then
      line = line .. '%#TabLineSel#'
    else
      line = line .. '%#TabLine#'
    end
    line = line .. '%' .. i .. 'T' -- Starts mouse click target region.
    line = line .. ' %{v:lua.wincent.tabline.label(' .. i .. ')} '
  end

  line = line .. '%#TabLineFill#'
  line = line .. '%T' -- Ends mouse click target region(s).
  return line
end

return render
