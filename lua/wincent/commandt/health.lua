-- SPDX-FileCopyrightText: Copyright 2022-present Greg Hurrell and contributors.
-- SPDX-License-Identifier: BSD-2-Clause

local health = vim.health -- after: https://github.com/neovim/neovim/pull/18720
  or require('health') -- before: v0.8.x

local path = require('wincent.commandt.private.path')
local lua_build_directory = vim.fn.fnamemodify((path.caller() + '../lib'):normalize(), ':~')
local ruby_build_directory =
  vim.fn.fnamemodify((path.caller() + '../../../../ruby/command-t/ext/command-t'):normalize(), ':~')

local function report_info()
  local version = require('wincent.commandt.version')
  health.info('Command-T version: ' .. version.version)
  if version.prerelease ~= '' then
    health.info('This is a prerelease (track the `release` branch for maximum stability)')
  end
  health.info('Lua build directory:\n' .. lua_build_directory)
  health.info('Ruby build directory:\n' .. ruby_build_directory)
end

local function check_lua_c_library()
  health.start('Checking that Lua C library has been built')

  local lib = require('wincent.commandt.private.lib')
  local result, _ = pcall(function()
    lib.epoch()
  end)

  if result then
    health.ok('Library can be `require`-ed and functions called')
  else
    health.error('Could not call functions in library', {
      'Try running `make` from:\n' .. lua_build_directory,
    })
  end
end

local function check_settings()
  health.start('Checking settings')

  if vim.o.switchbuf == 'usetab' then
    health.ok('\'switchbuf\' is set to recommended setting ("usetab")')
  else
    health.warn(
      string.format(
        '\'switchbuf\' is set to %s instead of recommended setting ("usetab")',
        vim.inspect(vim.o.switchbuf)
      )
    )
  end
end

local function check_external_dependencies()
  health.start('Checking for optional external dependencies')

  for executable, finder in pairs({
    fd = 'commandt.fd_finder',
    find = 'commandt.find_finder',
    git = 'commandt.git_finder',
    rg = 'commandt.rg_finder',
    watchman = 'commandt.watchman_finder',
  }) do
    if vim.fn.executable(executable) == 1 then
      health.ok(string.format('(optional) `%s` binary found', executable))
    else
      health.warn(string.format('(optional) `%s` binary is not in $PATH', executable), {
        string.format('%s requires `%s`', finder, executable),
      })
    end
  end
end

return {
  -- Run with `:checkhealth wincent.commandt`
  check = function()
    report_info()
    check_settings()
    check_lua_c_library()
    check_external_dependencies()
  end,
}
