-- SPDX-FileCopyrightText: Copyright 2026-present Greg Hurrell and contributors.
-- SPDX-License-Identifier: BSD-2-Clause

local ffi = require('ffi')

local c = require('wincent.commandt.private.lib.c')

-- Compatiblity wrapper that tries `commandt_scanner_new_exec` before
-- falling back to `commandt_scanner_new_command`.
local new_exec = (function()
  local ok, symbol = pcall(function()
    return c.commandt_scanner_new_exec
  end)
  if ok and symbol ~= nil then
    return symbol
  end
  return c.commandt_scanner_new_command
end)()

local function scanner_new_exec(command, drop, max_files)
  local scanner = new_exec(command, drop or 0, max_files or 0)
  ffi.gc(scanner, c.commandt_scanner_free)
  return scanner
end

return scanner_new_exec
