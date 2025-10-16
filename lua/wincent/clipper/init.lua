-- SPDX-FileCopyrightText: Copyright 2025-present Greg Hurrell. All rights reserved.
-- SPDX-License-Identifier: BSD-2-Clause

local clipper = {}

clipper.setup = function (options)
  require('wincent.clipper.private.config')(options)

  vim.api.nvim_create_user_command('Clip', require('wincent.clipper.clip'), {
    nargs = 0,
  })

  if options.autocmd ~= false then
    local group = vim.api.nvim_create_augroup('wincent.clipper', {})
    vim.api.nvim_create_autocmd('TextYankPost', {
      callback = require('wincent.clipper.clip'),
      group = group,
    })
  end
end

return clipper
