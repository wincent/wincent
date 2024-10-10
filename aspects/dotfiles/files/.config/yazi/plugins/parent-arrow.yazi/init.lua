-- See: https://yazi-rs.github.io/docs/tips#parent-arrow
local function entry(_, args)
  local parent = cx.active.parent
  if not parent then
    return
  end

  local offset = tonumber(args[1])
  if not offset then
    return ya.err(args[1], 'is not a number')
  end

  local start = parent.cursor + 1 + offset
  local end_ = offset < 0 and 1 or #parent.files
  local step = offset < 0 and -1 or 1
  for i = start, end_, step do
    local target = parent.files[i]
    if target and target.cha.is_dir then
      return ya.manager_emit('cd', { target.url })
    end
  end
end

return { entry = entry }
