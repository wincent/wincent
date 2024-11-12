-- For wrapping mappings related to folding and horizontal shifting so that
-- indent-blankline.nvim can update immediately when folds change.
local indent_blankline = {
  wrap_mapping = function(mapping)
    local has_ibl, ibl = pcall(require, 'ibl')
    if has_ibl then
      return mapping .. ":lua require('ibl').refresh(0)<CR>"
    else
      return mapping
    end
  end,
}

return indent_blankline
