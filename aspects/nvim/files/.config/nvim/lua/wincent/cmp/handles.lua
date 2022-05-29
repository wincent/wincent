-- Custom nvim-cmp source for GitHub handles.

local handles = {}

local registered = false

handles.setup = function()
  if registered then
    return
  end
  registered = true

  local has_cmp, cmp = pcall(require, 'cmp')

  if not has_cmp then
    return
  end

  local config = vim.fn.expand('~/.github-handles.json')
  if vim.fn.filereadable(config) == 0 then
    return
  end
  local addresses = vim.fn.json_decode(vim.fn.readfile(config))

  local source = {}

  source.new = function()
    return setmetatable({}, {__index = source})
  end

  source.get_trigger_characters = function()
    return { '@' }
  end

  source.get_keyword_pattern = function()
    -- Add dot to existing keyword characters (\k).
    return [[\%(\k\|\.\)\+]]
  end

  source.complete = function(self, request, callback)
    local input = string.sub(request.context.cursor_before_line, request.offset - 1)
    local prefix = string.sub(request.context.cursor_before_line, 1, request.offset - 1)

    if vim.startswith(input, '@') and (prefix == '@' or vim.endswith(prefix, ' @')) then
      local items = {}
      for handle, address in pairs(addresses) do
        table.insert(items, {
            filterText = handle .. ' ' .. address,
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

  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'luasnip' },
      { name = 'buffer' },
      { name = 'calc' },
      { name = 'emoji' },
      { name = 'path' },

      -- My custom sources.
      { name = 'handles' }, -- GitHub handles; eg. @wincent → Greg Hurrell <wincent@github.com>
    }),
  })
end

return handles
