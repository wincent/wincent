local math_keys = {}
for key in pairs(math) do
  table.insert(math_keys, key)
end

local source = {}

source.new = function()
  return setmetatable({}, { __index = source })
end

source.get_position_encoding_kind = function()
  return 'utf-8'
end

source.get_trigger_characters = function()
  return source._trigger_chars
end

source.get_keyword_pattern = function()
  return source._keyptn
end

source.complete = function(self, request, callback)
  local input = string.sub(request.context.cursor_before_line, request.offset)

  -- Resolve math_keys
  for _, key in ipairs(math_keys) do
    input = string.gsub(input, vim.pesc(key), 'math.' .. key)
  end

  -- Analyze column count.
  local delta = self:_analyze(input)
  if not delta then
    return callback({ isIncomplete = true })
  end
  while string.byte(input, delta + 1) == 32 do -- keep indent
    delta = delta + 1
  end
  local program = string.sub(input, delta + 1)

  -- Ignore if input has no math operators.
  if string.match(program, '^[ %d().]*$') ~= nil then
    return callback({ isIncomplete = true })
  end

  -- Ignore if failed to interpret to Lua.
  local m = load('return ' .. program)
  if type(m) ~= 'function' then
    return callback({ isIncomplete = true })
  end
  local status, value = pcall(m)

  -- Ignore if failed or not a number.
  if not status or type(value) ~= "number" then
    return callback({ isIncomplete = true })
  else
    value = tostring(value)
  end

  callback({
    items = {
      {
        word = string.sub(input, 1, delta) .. value,
        label = value,
        filterText = input,
        textEdit = {
          range = {
            start = {
              line = request.context.cursor.row - 1,
              character = delta + request.offset - 1,
            },
            ['end'] = {
              line = request.context.cursor.row - 1,
              character = request.context.cursor.col - 1,
            },
          },
          newText = value,
        },
      },
      {
        word = input .. ' = ' .. value,
        label = program .. ' = ' .. value,
        filterText = input,
        textEdit = {
          range = {
            start = {
              line = request.context.cursor.row - 1,
              character = delta + request.offset - 1,
            },
            ['end'] = {
              line = request.context.cursor.row - 1,
              character = request.context.cursor.col - 1,
            },
          },
          newText = program .. ' = ' .. value,
        },
      }
    },
    isIncomplete = true,
  })
end

source._analyze = function(_, input)
  local unmatched_parens = 0
  local o = string.byte('(')
  local c = string.byte(')')
  for i = #input, 1, -1 do
    if string.byte(input, i) == c then
      unmatched_parens = unmatched_parens - 1
    elseif string.byte(input, i) == o then
      if unmatched_parens == 0 then
        -- going in reverse -> extra '(' won't get matched -> cut here
        return i
      end
      unmatched_parens = unmatched_parens + 1
    end
  end

  if unmatched_parens == 0 then
    return 0
  end

  for i = 1, #input do
    if string.byte(input, i) == c then
      unmatched_parens = unmatched_parens + 1
      if unmatched_parens == 0 then
        return i
      end
    elseif string.byte(input, i) == o then
      unmatched_parens = unmatched_parens - 1
    end
  end

  return nil -- expression ends with extra ')'
end

source._trigger_chars = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', ')' }

-- Keyword matching pattern (vim regex)
source._keyptn = [[\s*\zs\(\d\+\(\.\d\+\)\?\|[ ()^*/%+-]\|]] ..
  table.concat(math_keys, '\\|') .. [[\)\+]]

return source
