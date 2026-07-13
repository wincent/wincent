-- SPDX-FileCopyrightText: Copyright 2026-present Greg Hurrell and contributors.
-- SPDX-License-Identifier: BSD-2-Clause

local ffi = require('ffi')

local c = require('wincent.commandt.private.lib.c')

-- Like `scanner_new_exec()`, but returns immediately and produces candidates on
-- a background thread. Poll `commandt_scanner_done()` and call
-- `commandt_scanner_stop()` (which `commandt_scanner_free()` also does) to join
-- the producer and reap the child.
local function scanner_new_exec_async(command, drop, max_files)
  local scanner = c.commandt_scanner_new_exec_async(command, drop or 0, max_files or 0)
  ffi.gc(scanner, c.commandt_scanner_free)
  return scanner
end

return scanner_new_exec_async
