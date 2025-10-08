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

  local success, handles_with_names_and_emails = pcall(function()
    local json_path = vim.fn.expand('~/.config/git/handles.jsonc')
    if vim.fn.filereadable(json_path) == 0 then
      error(json_path .. ' not readable')
    end

    -- readfile() returns a list of lines; filter comment lines, then join.
    local lines = vim.fn.readfile(json_path)
    local non_comments = vim.tbl_filter(function (line)
      return not line:match('^%s*//')
    end, lines)
    local json = table.concat(non_comments, '\n')

    return vim.json.decode(json)
  end)
  if not success then
    return
  end

  local source = {}

  source.new = function()
    return setmetatable({}, { __index = source })
  end

  source.get_trigger_characters = function()
    return { '@' }
  end

  source.get_keyword_pattern = function()
    -- Add dot and space to existing keyword characters (\k).
    return [[\%(\k\|\.\| \)\+]]
  end

  source.complete = function(self, request, callback)
    local input = string.sub(request.context.cursor_before_line, request.offset - 1)
    local prefix = string.sub(request.context.cursor_before_line, 1, request.offset - 1)

    if vim.startswith(input, '@') and (prefix == '@' or vim.endswith(prefix, ' @')) then
      local items = {}
      for handle, name_and_email in pairs(handles_with_names_and_emails) do
        table.insert(items, {
          data = {
            handle = handle,
          },
          filterText = '@' .. handle .. ' ' .. name_and_email,
          label = name_and_email,
          textEdit = {
            newText = name_and_email,
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
        })
      end
      callback({
        items = items,
        isIncomplete = true,
      })
    else
      callback({ isIncomplete = true })
    end
  end

  source.resolve = function(self, completion_item, callback)
    -- Show GitHub handle in documentation window.
    completion_item.documentation = '@' .. completion_item.data.handle
    callback(completion_item)
  end

  cmp.register_source('handles', source.new())
end

return handles
