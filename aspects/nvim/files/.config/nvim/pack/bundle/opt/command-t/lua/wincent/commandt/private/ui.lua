-- SPDX-FileCopyrightText: Copyright 2022-present Greg Hurrell and contributors.
-- SPDX-License-Identifier: BSD-2-Clause

local UI = {}

local MatchListing = require('wincent.commandt.private.match_listing')
local Prompt = require('wincent.commandt.private.prompt')
local Settings = require('wincent.commandt.private.settings')
local group_thousands = require('wincent.commandt.private.group_thousands')
local reverse = require('wincent.commandt.private.reverse')
local select_index = require('wincent.commandt.private.select_index')
local validate = require('wincent.commandt.private.validate')
local types = require('wincent.commandt.private.options.types')

local uv = vim.uv or vim.loop

-- How often (ms) to re-match and repaint while a scan is streaming in.
local SCAN_INTERVAL = 50

-- Braille spinner frames shown in the prompt title while a scan is streaming.
local SPINNER = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }

function UI.new()
  local self = {
    candidate_count = nil,
    cmdline_enter_autocmd = nil,
    current_finder = nil,
    current_window = nil,
    match_listing = nil,
    on_close = nil,
    on_open = nil,
    order = nil,
    prompt = nil,
    query = nil,
    results = nil,
    scanning = false,
    selected = nil,
    settings = Settings.new(),
    _spinner_index = nil,
    _timer = nil,
  }
  setmetatable(self, { __index = UI })
  return self
end

-- TODO: reasons to delete a window
-- 1. [DONE] user explicitly closes it with ESC
-- 2. [DONE] user explicitly accepts a selection
-- 3. [DONE] user navigates out of the window (WinLeave)
-- 4. [DONE] user uses a Vim command to close the window or the buffer
-- (we get this "for free" kind of thanks to WinLeave happening as soon as you
-- do anything that would move you out)

-- Re-run the current query against the finder and repaint the match listing.
-- `opts.query_changed` distinguishes a keystroke (reset selection to the best
-- match) from a streaming refresh (preserve the user's selection).
function UI:_refresh(opts)
  opts = opts or {}
  if not self.current_finder or not self.match_listing then
    return
  end
  local query = self.query or ''
  local previous_selected = self.selected

  self.results, self.candidate_count = self.current_finder.run(query)

  -- Defer the fallback decision until scanning has finished: a streaming finder
  -- legitimately reports zero candidates while it is still starting up.
  if not self.scanning then
    if #self.results > 0 or self.candidate_count > 0 then
      -- Once we've proved a finder works, we don't ever want to use fallback.
      self.current_finder.fallback = nil
    elseif self.current_finder.fallback then
      if self.current_finder.stop then
        self.current_finder.stop()
      end
      local finder, name = self.current_finder.fallback()
      self.current_finder = finder
      self.prompt.name = name or 'fallback'
      self.results, self.candidate_count = self.current_finder.run(query)
    end
  end

  if self.order == 'reverse' then
    reverse(self.results)
  end

  self.selected = select_index(previous_selected, #self.results, self.order, opts.query_changed)

  self.match_listing:update(self.results, { selected = self.selected })
  self:_update_status()
end

-- Start the periodic pump that re-matches and repaints as a streaming finder
-- produces candidates on its background thread.
function UI:_start_scanning()
  self.scanning = true
  self._spinner_index = 1
  if self._timer == nil then
    self._timer = uv.new_timer()
  end
  self._timer:start(0, SCAN_INTERVAL, function()
    -- Timer callbacks run in a "fast" context; defer to a normal context so we
    -- can touch buffers and windows.
    vim.schedule(function()
      self:_tick()
    end)
  end)
end

function UI:_tick()
  if not self.current_finder or not self.scanning then
    return
  end
  local finder = self.current_finder
  local done = (finder.done == nil) or finder.done()
  if done then
    self.scanning = false
  else
    self._spinner_index = (self._spinner_index % #SPINNER) + 1
  end
  self:_refresh({ query_changed = false })
  if done then
    self:_stop_timer()
    if finder.stop then
      finder.stop()
    end
  end
end

function UI:_stop_timer()
  if self._timer then
    self._timer:stop()
    if not self._timer:is_closing() then
      self._timer:close()
    end
    self._timer = nil
  end
end

function UI:_update_status()
  if not self.prompt then
    return
  end
  -- Keep the right-hand block hidden until the first candidate has arrived, so an
  -- empty scan (or the synchronous fallback walk) doesn't show a frozen "0 / 0".
  -- Once candidates exist, show "displayed / scanned" for every finder, prefixed
  -- with the spinner while a scan is still streaming.
  if (self.candidate_count or 0) > 0 then
    local displayed = self.results and #self.results or 0
    local status = group_thousands(displayed) .. ' / ' .. group_thousands(self.candidate_count)
    if self.scanning then
      status = SPINNER[self._spinner_index or 1] .. ' ' .. status
    end
    self.prompt:set_status(status)
  else
    self.prompt:set_status(nil)
  end
end

function UI:_close()
  -- Stop any in-progress streaming scan and release the producer thread and
  -- child process before tearing down the windows.
  self.scanning = false
  self:_stop_timer()
  if self.current_finder and self.current_finder.stop then
    self.current_finder.stop()
  end

  -- Restore global settings.
  self.settings.hlsearch = nil

  if self.match_listing then
    self.match_listing:close()
    self.match_listing = nil
  end
  if self.prompt then
    self.prompt:close()
    self.prompt = nil
  end
  if self.cmdline_enter_autocmd ~= nil then
    vim.api.nvim_del_autocmd(self.cmdline_enter_autocmd)
    self.cmdline_enter_autocmd = nil
  end
  if self.current_window then
    -- Due to autocommand nesting, and the fact that we call `close()` for
    -- `WinLeave`, `WinClosed`, or us calling `:close()`, we have to be careful
    -- to avoid infinite recursion here, by setting `current_window` to `nil`
    -- _before_ calling `nvim_set_current_win()`:
    local win = self.current_window
    self.current_window = nil
    vim.api.nvim_set_current_win(win)
  end
  if self.on_close then
    self.on_close()
    self.on_close = nil
  end
end

function UI:_open(ex_command)
  self:_close()
  if self.results and #self.results > 0 then
    local result = self.results[self.selected]
    if self.on_open then
      result = self.on_open(result)
    end

    -- Defer, to give autocommands a chance to run.
    vim.defer_fn(function()
      self.current_finder.open(result, ex_command)
    end, 0)
  end
  self.on_open = nil
end

local schema = {
  kind = 'table',
  keys = {
    mode = types.mode,
    name = { kind = 'string' },
    on_close = { kind = 'function', optional = true },
    on_open = { kind = 'function', optional = true },
  },
}

local validate_config = function(config)
  local errors = validate('', {}, config, schema, {})
  if #errors > 0 then
    error('UI:show(): ' .. errors[1])
  end
end

--- Display the Command-T UI, consisting of a Prompt window and a MatchListing
--- window.
---
--- @param finder any
--- @param options any Top-level Command-T options.
--- @param config any `UI`-specific config.
function UI:show(finder, options, config)
  validate_config(config)
  self.current_finder = finder

  self.current_window = vim.api.nvim_get_current_win()

  self.on_close = config.on_close
  self.on_open = config.on_open

  -- Temporarily override global settings.
  -- For now just 'hlsearch', but may add more later (see
  -- ruby/command-t/lib/command-t/match_window.rb)
  self.settings.hlsearch = false

  -- Work around an autocommand bug. We don't reliably get `WinClosed` events,
  -- or if we do, our call to `nvim_del_autocmd()` doesn't always clean up for
  -- us. So, we add some window-related autocommands to a group which we always
  -- reset every time we show a new UI.
  vim.api.nvim_create_augroup('CommandTWindow', { clear = true })

  local border = options.match_listing.border ~= 'winborder' and options.match_listing.border or nil
  self.match_listing = MatchListing.new({
    border = border,
    height = options.height,
    icons = config.mode ~= 'virtual' and options.match_listing.icons or false,
    margin = options.margin,
    position = options.position,
    selection_highlight = options.selection_highlight,
    truncate = options.match_listing.truncate,
  })
  self.match_listing:show()

  self.results = nil
  self.selected = nil
  self.query = ''
  self.order = options.order
  border = options.prompt.border ~= 'winborder' and options.prompt.border or nil
  self.prompt = Prompt.new({
    border = border,
    height = options.height,
    mappings = options.mappings,
    margin = options.margin,
    name = config.name,
    on_change = function(query)
      self.query = query
      self:_refresh({ query_changed = true })
    end,
    on_leave = function()
      self:_close()
    end,
    -- TODO: decide whether we want an `index`, a string, or just to base it off
    -- our notion of current selection
    on_open = function(ex_command)
      self:_open(ex_command)
    end,
    on_select = function(choice)
      if self.results and #self.results > 0 then
        if choice.absolute then
          if choice.absolute > 0 then
            self.selected = math.min(choice.absolute, #self.results)
          elseif choice.absolute < 0 then
            self.selected = math.max(#self.results + choice.absolute + 1, 1)
          else -- Absolute "middle".
            self.selected = math.min(math.floor(#self.results / 2) + 1, #self.results)
          end
        elseif choice.relative then
          if choice.relative > 0 then
            self.selected = math.min(self.selected + choice.relative, #self.results)
          else
            self.selected = math.max(self.selected + choice.relative, 1)
          end
        end
        self.match_listing:select(self.selected)
      end
    end,
    position = options.position,
  })
  self.prompt:show()

  -- Streaming finders keep producing candidates in the background; drive
  -- periodic re-matches and repaints until production finishes.
  if self.current_finder.streaming then
    self:_start_scanning()
  end

  if self.cmdline_enter_autocmd == nil then
    self.cmdline_enter_autocmd = vim.api.nvim_create_autocmd('CmdlineEnter', {
      callback = function()
        self:_close()
      end,
    })
  end
end

return UI
