--- Convenience wrapper around `nvim_replace_termcodes()` for use when defining
--- expression mappings; eg:
---
---    nnoremap('<C-a>', function () return keycodes('<Tab>') end, {expr = true})
---
--- or passing into `nvim_feed_keys()`.
---
--- Takes a string representation of a series of key presses and
--- mapping's RHS (eg. "<Tab>") into an
--- internal representation (eg. "\t").
local function keys(string_with_keycodes)
  return vim.api.nvim_replace_termcodes(string_with_keycodes, true, true, true)
end

return keys
