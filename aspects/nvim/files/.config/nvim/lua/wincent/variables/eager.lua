local eager = function()
  vim.g.WincentQuickfixStatusline = '%7*'
    .. '%{v:lua.wincent.statusline.lhs()}'
    .. '%*'
    .. '%4*'
    .. ''
    .. ' '
    .. '%*'
    .. '%3*'
    .. '%q'
    .. ' '
    .. '%{get(w:,"quickfix_title","")}'
    .. '%*'
    .. '%<'
    .. ' '
    .. '%='
    .. ' '
    .. ''
    .. '%5*'
    .. '%{v:lua.wincent.statusline.rhs()}'
    .. '%*'
end

return eager
