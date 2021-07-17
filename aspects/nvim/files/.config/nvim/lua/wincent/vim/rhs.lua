-- Convenience wrapper around nvim_replace_termcodes() for use when defining
-- expression mappings; eg:
--
--    nnoremap('<C-a>', function () return rhs('<Tab>') end, {expr = true})
--
-- Converts a string representation of a mapping's RHS (eg. "<Tab>") into an
-- internal representation (eg. "\t").
local rhs = function(rhs_str)
  return vim.api.nvim_replace_termcodes(rhs_str, true, true, true)
end

return rhs
