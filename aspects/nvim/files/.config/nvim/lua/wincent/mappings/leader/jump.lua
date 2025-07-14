local function jump(mapping, delta)
  -- Calculate the number of steps to move up or down through the jump list in
  -- order to get to a new bufnr (we use bufnr because not all entries will have a
  -- filename).
  local count = 0
  local jumplist, idx = unpack(vim.fn.getjumplist())
  local previous_entry = jumplist[idx]
  local next_idx = idx + delta
  while next_idx > 0 and next_idx < #jumplist do
    count = count + 1
    local next_entry = jumplist[next_idx]
    if next_entry.bufnr ~= previous_entry.bufnr then
      -- We found the next file; we're done.
      require('wincent.nvim.feedkeys')(count .. mapping)
      vim.cmd.echo() -- Clear any previous "No more jumps!" message.
      return
    else
      previous_entry = next_entry
      next_idx = next_idx + delta
    end
  end
  vim.notify('No more jumps!', vim.log.levels.WARN)
end

return jump
