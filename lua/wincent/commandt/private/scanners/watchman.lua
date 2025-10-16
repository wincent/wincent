-- SPDX-FileCopyrightText: Copyright 2022-present Greg Hurrell and contributors.
-- SPDX-License-Identifier: BSD-2-Clause

local M = {}

local sockname = nil

-- TODO: figure out when to clean this up
local socket = nil

-- Run `watchman get-sockname` to get current socket name; `watchman` will spawn
-- in response to this command if it is not already running.
--
-- See: https://facebook.github.io/watchman/docs/cmd/get-sockname.html
local get_sockname = function()
  if sockname == nil then
    if vim.fn.executable('watchman') == 1 then
      local output = vim.fn.systemlist('watchman get-sockname')
      local decoded = vim.fn.json_decode(output)
      if decoded['error'] then
        error(
          'wincent.commandt.scanners.watchman.get_sockname(): watchman get-sockname error = '
            .. tostring(decoded['error'])
        )
      else
        sockname = decoded['sockname']
      end
    else
      error('wincent.commandt.scanners.watchman.get_sockname(): no watchman executable')
    end
  end
  return sockname
end

local get_socket = function()
  if socket == nil then
    local name = get_sockname()
    if name == nil then
      error('wincent.commandt.scanners.watchman.get_socket(): no sockname')
    end
    local lib = require('wincent.commandt.private.lib')
    socket = lib.watchman_connect(name)
  end
  return socket
end

-- Internal: Used by the benchmark suite so that we can identify this scanner
-- from among others.
M.name = 'watchman'

-- Internal: Used by the benchmark suite so that we can avoid calling `vim` functions
-- inside `get_sockname()` from our pure-C benchmark harness.
M.set_sockname = function(name)
  sockname = name
end

-- Equivalent to:
--
--    watchman -j <<-JSON
--      ["query", "/path/to/root", {
--        "expression": ["type", "f"],
--        "fields": ["name"],
--        "relative_root": "some/relative/path"
--      }]
--    JSON
--
-- If `relative_root` is `nil`, it will be omitted from the query.
--
local query = function(root, relative_root)
  local lib = require('wincent.commandt.private.lib')

  return lib.watchman_query(root, relative_root, get_socket())
end

-- Equivalent to `watchman watch-project $root`.
--
-- Returns a table with `watch` and `relative_path` properties. `relative_path`
-- my be `nil`.
local watch_project = function(root)
  local lib = require('wincent.commandt.private.lib')
  return lib.watchman_watch_project(root, get_socket())
end

-- Weak table to store query results keyed by scanner to prevent GC.
local scanner_results = setmetatable({}, { __mode = 'k' })

M.scanner = function(directory)
  local lib = require('wincent.commandt.private.lib')
  local project = watch_project(vim.fn.fnamemodify(directory, ':p'))
  if project.error then
    error(project.error)
    -- TODO: in the future (once Watchman is more solid), degrade gracefully
    -- instead; for now, explode loudly.
  end

  local result = query(project.watch, project.relative_path)
  if result.error ~= nil then
    -- TODO: in the future (once Watchman is more solid), degrade gracefully
    -- instead; for now, explode loudly.
    error(result.error)
  end
  local scanner = lib.scanner_new_str(result.raw.files, result.raw.count)

  -- Protect results from GC as long as `scanner` exists.
  scanner_results[scanner] = result
  return scanner
end

return M
