local do_not_remap_keys = 'n'
local handle_keys_as_if_typed = 't'
local mode = do_not_remap_keys .. handle_keys_as_if_typed

--- Convenience wrapper for the common case of calling `nvim_feedkeys()` with
--- keycodes (eg. "<Tab>", "<Down>" etc) replaced.
local function feedkeys(keys)
  return vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes(keys, true, true, true),
    mode,
    false -- Do not escape keycodes.
  )
end

return feedkeys
