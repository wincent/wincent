-- Based on: http://vim.wikia.com/wiki/Identify_the_syntax_highlighting_group_used_at_the_cursor
local function get_highlight_group()
  local pos = vim.api.nvim_win_get_cursor(0)
  local line = pos[1]
  local col = pos[2]
  local synID = vim.fn.synID
  local synIDattr = vim.fn.synIDattr
  local synIDtrans = vim.fn.synIDtrans
  return (
    'hi<'
    .. synIDattr(synID(line, col, true), 'name')
    .. '> trans<'
    .. synIDattr(synID(line, col, false), 'name')
    .. '> lo<'
    .. synIDattr(synIDtrans(synID(line, col, true)), 'name')
    .. '>'
  )
end

return get_highlight_group
