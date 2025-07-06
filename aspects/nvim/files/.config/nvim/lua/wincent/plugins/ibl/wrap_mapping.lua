--- For wrapping mappings related to folding and horizontal shifting so that
--- indent-blankline.nvim can update immediately when folds change.
---
--- @param mapping string
--- @return string
local function wrap_mapping(mapping)
  local has_ibl = pcall(require, 'ibl')
  if has_ibl then
    return mapping .. ":lua require('ibl').refresh(0)<CR>"
  else
    return mapping
  end
end

return wrap_mapping
