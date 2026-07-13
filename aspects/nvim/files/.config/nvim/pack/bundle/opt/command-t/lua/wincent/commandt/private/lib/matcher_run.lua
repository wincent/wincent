-- SPDX-FileCopyrightText: Copyright 2026-present Greg Hurrell and contributors.
-- SPDX-License-Identifier: BSD-2-Clause

local ffi = require('ffi')

local c = require('wincent.commandt.private.lib.c')

local function matcher_run(matcher, needle)
  return ffi.gc(c.commandt_matcher_run(matcher, needle), c.commandt_result_free)
end

return matcher_run
