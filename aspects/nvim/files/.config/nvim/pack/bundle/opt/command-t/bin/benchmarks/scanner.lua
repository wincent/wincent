#!/usr/bin/env luajit

-- SPDX-FileCopyrightText: Copyright 2014-present Greg Hurrell and contributors.
-- SPDX-License-Identifier: BSD-2-Clause

local ffi = require('ffi')

local pwd = os.getenv('PWD')
local lua_directory = pwd .. '/' .. debug.getinfo(1).source:match('@?(.*/)') .. '../../lua'

package.path = lua_directory .. '/?.lua;' .. package.path
package.path = lua_directory .. '/?/init.lua;' .. package.path

local benchmark = require('wincent.commandt.private.benchmark')

benchmark({
  config = 'wincent.commandt.benchmark.configs.scanner',

  log = 'wincent.commandt.benchmark.logs.scanner',

  setup = function(config)
    collectgarbage()
    local scanner = nil
    if config.stub then
      -- For scanners that otherwise depend on Neovim for a list of candidates.
      config.stub()
    end
    if type(config.source) == 'string' then
      scanner = require(config.source)
    elseif type(config.source) == 'function' then
      scanner = config.source()
    else
      error('`source` should be a string or function')
    end
    if scanner.name == 'watchman' then
      -- We don't have a real JSON parser here, so we fake it.
      local fallback = '/opt/homebrew/var/run/watchman/wincent-state/sock'
      local file = assert(io.popen('watchman get-sockname', 'r'))
      local output = file:read('*all')
      file:close()
      local name = output:match('"sockname":%s*"([^"]+)"') or fallback
      scanner.set_sockname(name)
    end
    return scanner
  end,

  run = function(config, setup)
    local scanner = setup.scanner(pwd) -- For now, only Watchman wants pwd.
    for i = 1, scanner.count do
      ffi.string(scanner.candidates[i - 1].contents)
    end
  end,

  teardown = function(config)
    if config.unstub then
      config.unstub()
    end
  end,
})
