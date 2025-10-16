-- SPDX-FileCopyrightText: Copyright 2025-present Greg Hurrell. All rights reserved.
-- SPDX-License-Identifier: BSD-2-Clause

local function executable()
  if vim.fn.executable('nc') == 1 then
    -- Try to figure out whether `-N` switch is supported and required.
    -- Will match:
    --
    -- - `%s+` (1 or more whitespace)
    -- - `-n` (literal hyphen followed by "n")
    -- - `%s+` (1 or more whitespace)
    -- - `.-` (0 or more of any character)
    -- - `shutdown (literal "shutdown")
    --
    local help = string.lower(vim.fn.system('nc -h'))
    if help:match('%s+-n%s+.-shutdown') then
      -- Ubuntu, FreeBSD and similar. These need `-N` to "shutdown(2) the
      -- network socket after EOF on the input". See:
      -- - http://manpages.ubuntu.com/manpages/bionic/man1/nc_openbsd.1.html
      -- - https://www.freebsd.org/cgi/man.cgi?nc
      return 'nc -N'
    else
      -- Darwin supports but does not require `-N` (it does something else).
      -- CentOS (etc) does not support nor need `-N`.
      return 'nc'
    end
  end
end

local function has_value(list, value)
  for _, candidate in ipairs(list) do
    if candidate == value then
      return true
    end
  end
  return false
end


local function clip()
  local config = require('wincent.clipper.private.config')
  if vim.v.event.operator and not has_value(config.operators or { 'd', 'y' }, vim.v.event.operator) then
    return
  end
  local contents = vim.fn.getreg('')
  if type(config.invocation) == 'string' then
    vim.fn.system(config.invocation, contents)
  else
    local exe = executable()
    if exe ~= '' then
      if type(config.socket) == 'string' then
        vim.fn.system(exe .. ' -U ' .. config.socket, contents)
      else
        local address = type(config.address) == 'string' and config.address or 'localhost'
        local port = type(config.port) == 'number' and config.port or 8377
        vim.fn.system(exe .. ' ' .. address .. ' ' .. tostring(port), contents)
      end
    else
      error('clipper.clip(): executable does not exist')
    end
  end
end

return clip
