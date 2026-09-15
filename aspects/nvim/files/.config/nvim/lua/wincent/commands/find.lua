--- Runs `find` and puts the results in the quickfix list.
---
--- Not async because we want `:cfirst` to jump to the first result.
---
--- @param args string
local function find(args)
  local command = 'find ' .. args

  local lines = vim.fn.systemlist(command)

  local items = {}

  for _, line in ipairs(lines) do
    if line ~= '' then
      table.insert(items, { filename = line })
    end
  end

  -- Building the list directly avoids the old implementation's `set
  -- errorformat+=%f`, which permanently mutated a global option on every call.
  vim.fn.setqflist({}, ' ', { items = items, title = command })

  if #items > 0 then
    vim.cmd.cfirst()
  end
end

return find
