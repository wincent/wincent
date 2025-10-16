-- Copyright 2015-present Greg Hurrell. All rights reserved.
-- Licensed under the terms of the MIT license.

local chooser = require('wincent.corpus.private.chooser')
local directories = require('wincent.corpus.private.directories')
local in_directory = require('wincent.corpus.private.in_directory')
local util = require('wincent.corpus.private.util')

local complete = function(arglead, cmdline, _cursor_pos)
  if in_directory() then
    local file = chooser.get_selected_file()
    if file ~= nil then
      local title = chooser.get_selected_file():sub(1, -4) -- strip ".md"
      local prefix, _ = cmdline:gsub('^%s*Corpus!?%s+', '') -- strip "Corpus "
      if vim.startswith(title, prefix) then
        -- If on "foo bar bazzzz"
        --                   ^
        -- Must return "bazzzz", not "zzz".
        local suffix = title:sub(prefix:len() - arglead:len() + 1, -1)
        return { suffix }
      end
    end
  else
    return util.list.filter(directories(), function(directory, _i)
      return vim.startswith(directory, arglead)
    end)
  end
end

return complete
