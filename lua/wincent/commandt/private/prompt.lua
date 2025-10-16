-- SPDX-FileCopyrightText: Copyright 2022-present Greg Hurrell and contributors.
-- SPDX-License-Identifier: BSD-2-Clause

local Window = require('wincent.commandt.private.window')
local merge = require('wincent.commandt.private.merge')
local types = require('wincent.commandt.private.options.types')
local validate = require('wincent.commandt.private.validate')

local Prompt = {}

local mt = {
  __index = Prompt,
  __newindex = function(t, k, v)
    if k == 'name' then
      Prompt.set_name(t, v)
    else
      rawset(t, k, v)
    end
  end,
}

local schema = {
  kind = 'table',
  keys = {
    border = types.border,
    height = types.height,
    mappings = types.mappings,
    margin = types.margin,
    name = { kind = 'string' },
    on_change = { kind = 'function', optional = true },
    on_leave = { kind = 'function', optional = true },
    on_open = { kind = 'function', optional = true },
    on_select = { kind = 'function', optional = true },
    position = types.position,
  },
}

local validate_options = function(options)
  local errors = validate('', {}, options, schema, {})
  if #errors > 0 then
    error('Prompt.new(): ' .. errors[1])
  end
end

function Prompt.new(options)
  options = merge({
    border = nil,
    height = 15,
    mappings = {},
    margin = 0,
    name = nil,
    on_change = nil,
    on_leave = nil,
    on_open = nil,
    on_select = nil,
    position = 'bottom',
  }, options or {})
  validate_options(options)
  local p = {
    _border = options.border,
    _height = options.height,
    _mappings = options.mappings,
    _margin = options.margin,
    _name = options.name,
    _on_change = options.on_change,
    _on_leave = options.on_leave,
    _on_open = options.on_open,
    _on_select = options.on_select,
    _position = options.position,
    _window = nil,
  }
  setmetatable(p, mt)
  return p
end

function Prompt:close()
  if self._window then
    self._window:close()
  end
end

function Prompt:set_name(name)
  self._name = name
  if self._window then
    self._window:set_title(self:title())
  end
end

function Prompt:title()
  return self._name and ('CommandT [' .. self._name .. ']') or 'CommandT'
end

function Prompt:show()
  local bottom = nil
  local top = nil
  if self._position == 'center' then
    local available_height = vim.o.lines - vim.o.cmdheight
    local used_height = self._height -- note we need to know how high the match listing is going to be
      + 2 -- match listing border
      + 3 -- our height
    local remaining_height = math.max(1, available_height - used_height)
    top = math.floor(remaining_height / 2)
  elseif self._position == 'bottom' then
    bottom = 0
  else
    top = 0
  end

  if self._window == nil then
    self._window = Window.new({
      border = self._border,
      bottom = bottom,
      buftype = 'prompt',
      filetype = 'CommandTPrompt',
      margin = self._margin,
      on_change = function(contents)
        if self._on_change then
          self._on_change(contents)
        end
      end,
      on_close = function()
        self._window = nil
      end,
      on_leave = self._on_leave,
      position = self._position,
      title = self:title(),
      top = top,
    })
  end

  self._window:show()

  local callbacks = {
    close = function()
      if self._window then
        self._window:close()
      end
    end,
    open = function()
      if self._on_open then
        self._on_open('edit')
      end
    end,
    open_split = function()
      if self._on_open then
        self._on_open('split')
      end
    end,
    open_tab = function()
      if self._on_open then
        self._on_open('tabedit')
      end
    end,
    open_vsplit = function()
      if self._on_open then
        self._on_open('vsplit')
      end
    end,
    select_first = function()
      if self._on_select then
        self._on_select({ absolute = 1 })
      end
    end,
    select_last = function()
      if self._on_select then
        self._on_select({ absolute = -1 })
      end
    end,
    select_middle = function()
      if self._on_select then
        self._on_select({ absolute = 0 })
      end
    end,
    select_next = function()
      if self._on_select then
        self._on_select({ relative = 1 })
      end
    end,
    select_previous = function()
      if self._on_select then
        self._on_select({ relative = -1 })
      end
    end,
  }
  for mode, mappings in pairs(self._mappings) do
    for lhs, rhs in pairs(mappings) do
      if rhs then
        self._window:map(mode, lhs, callbacks[rhs] or rhs)
      end
    end
  end
  self._window:focus()
end

return Prompt
