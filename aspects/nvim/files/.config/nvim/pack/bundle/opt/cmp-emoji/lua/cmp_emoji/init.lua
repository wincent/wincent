local source = {}

source.new = function()
  local self = setmetatable({}, { __index = source })
  self.commit_items = nil
  self.insert_items = nil
  return self
end

source.get_trigger_characters = function()
  return { ':' }
end

source.get_keyword_pattern = function()
  return [=[\%([[:space:]"'`]\|^\)\zs:[[:alnum:]_\-\+]*:\?]=]
end

source.complete = function(self, params, callback)
  -- Avoid unexpected completion.
  if not vim.regex(self.get_keyword_pattern() .. '$'):match_str(params.context.cursor_before_line) then
    return callback()
  end

  if self:option(params).insert then
    if not self.insert_items then
      self.insert_items = vim.tbl_map(function(item)
        item.word = nil
        return item
      end, require('cmp_emoji.items')())
    end
    callback(self.insert_items)
  else
    if not self.commit_items then
      self.commit_items = require('cmp_emoji.items')()
    end
    callback(self.commit_items)
  end
end

source.option = function(_, params)
  return vim.tbl_extend('force', {
    insert = false,
  }, params.option)
end

return source

