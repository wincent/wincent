-- SPDX-FileCopyrightText: Copyright 2025-present Greg Hurrell. All rights reserved.
-- SPDX-License-Identifier: BSD-2-Clause

local storage = {}

local function warn(message)
  vim.api.nvim_echo({{'nvim-clipper: ' .. message, 'ErrorMsg'}}, true, {})
end

local config = setmetatable(storage, {
  __call = function (self, options)
    if type(options) ~= 'table' then
      error('clipper.private.config() requires a table')
    else
      for key, value in pairs(options) do
        if key == 'address' then
          if type(value) ~= 'string' then
            warn('ignoring non-string value for `address`')
          else
            self[key] = value
          end
        elseif key == 'autocmd' then
          if type(value) ~= 'boolean' then
            warn('ignoring non-boolean value for `autocmd`')
          else
            self[key] = value
          end
        elseif key == 'invocation' then
          if type(value) ~= 'string' then
            warn('ignoring non-string value for `invocation`')
          else
            self[key] = value
          end
        elseif key == 'operators' then
          if type(value) ~= 'table' or not vim.islist(value) then
            warn('ignoring non-list value for `operators`')
          else
            self[key] = value
          end
        elseif key == 'port' then
          if type(value) ~= 'number' then
            warn('ignoring non-number value for `port`')
          else
            self[key] = value
          end
        elseif key == 'socket' then
          if type(value) ~= 'string' then
            warn('ignoring non-string value for `socket`')
          else
            self[key] = value
          end
        else
            warn('ignoring unrecognized key `' .. key .. '`')
        end
      end
    end
  end
})

return config
