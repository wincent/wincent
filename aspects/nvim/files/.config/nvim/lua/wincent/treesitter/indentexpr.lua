local function indentexpr()
  local treesitter, has_treesitter = pcall(require, 'nvim-treesitter')
  if has_treesitter then
    return treesitter.indentexpr()
  else
    return ''
  end
end

return indentexpr
