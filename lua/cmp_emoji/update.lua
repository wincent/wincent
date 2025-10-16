-- Generates the emoji data Lua file using this as a source: https://raw.githubusercontent.com/iamcal/emoji-data/master/emoji.json

local M = {}

M._read = function(path)
  return vim.fn.json_decode(vim.fn.readfile(path))
end

M._write = function(path, data)
  local h = io.open(path, 'w')
  h:write(data)
  io.close(h)
end

M.to_string = function(chars)
  local nrs = {}
  for _, char in ipairs(chars) do
    table.insert(nrs, vim.fn.eval(([[char2nr("\U%s")]]):format(char)))
  end
  return vim.fn.list2str(nrs, true)
end

M.to_item = function(emoji, short_name)
  short_name = ':' .. short_name .. ':'
  return ("{ word = '%s'; label = '%s'; insertText = '%s'; filterText = '%s' };\n"):format(
    short_name,
    emoji .. ' ' .. short_name,
    emoji,
    short_name
  )
end

M.to_items = function(emoji, short_names)
  local variants = ''

  for _, short_name in ipairs(short_names) do
    variants = variants .. M.to_item(emoji, short_name)
  end

  return variants
end

M.update = function()
  local items = ''
  for _, emoji in ipairs(M._read('./emoji.json')) do
    local char = M.to_string(vim.split(emoji.unified, '-'))

    local valid = true
    valid = valid and vim.fn.strdisplaywidth(char) <= 2 -- Ignore invalid ligatures
    if valid then
      items = items .. M.to_items(char, emoji.short_names)
    end
  end
  M._write('./items.lua', ('return function() return {\n%s} end'):format(items))
end

return M

