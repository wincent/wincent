vim.g.WincentQuickfixStatusline =
      '%7*' ..
      [[%{luaeval("require'wincent.statusline'.lhs()")}]] ..
      '%*' ..
      '%4*' ..
      '' ..
      ' ' ..
      '%*' ..
      '%3*' ..
      '%q' ..
      ' ' ..
      '%{get(w:,"quickfix_title","")}' ..
      '%*' ..
      '%<' ..
      ' ' ..
      '%=' ..
      ' ' ..
      '' ..
      '%5*' ..
      [[%{luaeval("require'wincent.statusline'.rhs()")}]] ..
      '%*'

vim.defer_fn(function()
  local wincent = require'wincent'
  wincent.variables()
end, 0)
