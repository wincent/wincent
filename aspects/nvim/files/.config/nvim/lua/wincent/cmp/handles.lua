-- Custom nvim-cmp source for GitHub handles.

local handles = {}

local registered = false

handles.setup = function()
  if registered then
    return
  end
  registered = true

  local config = vim.fn.expand('~/.github-handles.json')
  if vim.fn.filereadable(config) == 0 then
    return
  end
  local addresses = vim.fn.json_decode(vim.fn.readfile(config))

  local cmp = require('cmp')

  local source = {}

  source.new = function()
    return setmetatable({}, {__index = source})
  end

  source.get_trigger_characters = function()
    return { '@' }
  end

  source.complete = function(self, request, callback)
    local input = string.sub(request.context.cursor_before_line, request.offset - 1)
    local prefix = string.sub(request.context.cursor_before_line, 1, request.offset - 1)

    if vim.startswith(input, '@') and (prefix == '@' or vim.endswith(prefix, ' @')) then
      local items = {}
      for handle, address in pairs(addresses) do
        table.insert(items, {
            label = address,
            textEdit = {
              newText = address,
              range = {
                start = {
                  line = request.context.cursor.row - 1,
                  character = request.context.cursor.col - 1 - #input,
                },
                ['end'] = {
                  line = request.context.cursor.row - 1,
                  character = request.context.cursor.col - 1,
                },
              },
            },
          }
        )
      end
      callback {
        items = items,
        isIncomplete = true,
      }
    else
      callback({isIncomplete = true})
    end
  end

  cmp.register_source('handles', source.new())
end

return handles
