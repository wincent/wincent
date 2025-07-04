-- Custom nvim-cmp source for git commit hashes.

local commits = {}

local registered = false
local cache = {}

commits.setup = function()
  if registered then
    return
  end
  registered = true

  local has_cmp, cmp = pcall(require, 'cmp')
  if not has_cmp then
    return
  end

  local source = {}

  source.new = function()
    return setmetatable({}, { __index = source })
  end

  -- source.get_trigger_characters = function()
  --   return {}
  -- end

  source.get_keyword_pattern = function()
    -- Match hexadecimal characters
    return [[\%([0-9a-fA-F]\)\+]]
  end

  local function create_completion_item(full_hash, subject, date, request, input)
    local hash_prefix = string.sub(full_hash, 1, math.max(16, #input))
    local completion_text = string.format('%s ("%s", %s)', hash_prefix, subject, date)
    return {
      items = {
        {
          label = completion_text,
          textEdit = {
            newText = completion_text,
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
          documentation = {
            kind = 'markdown',
            value = string.format('**Commit:** %s\n**Subject:** %s\n**Date:** %s', full_hash, subject, date),
          },
        },
      },
      isIncomplete = true,
    }
  end

  source.complete = function(self, request, callback)
    local input = string.sub(request.context.cursor_before_line, request.offset - 1)
    local prefix = string.sub(request.context.cursor_before_line, 1, request.offset - 1)

    -- Check if we have a likely hex string (expect at least 1 number and 1
    -- letter).
    if
      #input >= 12
      and #input <= 40
      and string.match(input, '^%x+$')
      and string.match(input, '%d')
      and string.match(input, '%a')
    then
      local hash = input

      -- Check cache first
      if cache[hash] then
        local cached = cache[hash]
        callback(create_completion_item(cached.full_hash, cached.subject, cached.date, request, input))
        return
      end

      -- Get commit info using git command
      local cmd = string.format("command git show --no-patch --format='%%H%%x00%%s%%x00%%as' %s 2>/dev/null", hash)
      local handle = io.popen(cmd)
      if handle then
        local result = handle:read('*a')
        handle:close()

        if result and result ~= '' then
          local full_hash, subject, date = string.match(vim.trim(result), '^(.+)%z([^%z]*)%z(.+)$')
          if full_hash and subject and date then
            -- Cache the result
            cache[hash] = {
              full_hash = full_hash,
              subject = subject,
              date = date,
            }

            callback(create_completion_item(full_hash, subject, date, request, input))
            return
          end
        end
      end
    end

    callback({ isIncomplete = true })
  end

  cmp.register_source('commits', source.new())
end

return commits
