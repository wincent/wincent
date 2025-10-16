-- Copyright 2015-present Greg Hurrell. All rights reserved.
-- Licensed under the terms of the MIT license.

local warned = {}

local deprecated = function(name)
  if not warned[name] then
    warned[name] = true
    if name == '' then
      vim.api.nvim_err_writeln('Calling `corpus{}` directly is deprecated;')
      vim.api.nvim_err_writeln("use `require'wincent.corpus'{}` instead.")
    else
      vim.api.nvim_err_writeln('Calling `' .. name .. '()` directly on `corpus` is deprecated;')
      vim.api.nvim_err_writeln("use `require'wincent.corpus'." .. name .. '()` instead.')
    end
    vim.api.nvim_err_writeln('This compatibility shim will be removed in a future release.')
  end
end

local corpus = {
  choose = function(selection, bang)
    deprecated('choose')
    return require('wincent.corpus').choose(selection, bang)
  end,

  cmdline_changed = function(char)
    deprecated('cmdline_changed')
    return require('wincent.corpus').cmdline_changed(char)
  end,

  cmdline_enter = function()
    deprecated('cmdline_enter')
    return require('wincent.corpus').cmdline_enter()
  end,

  cmdline_leave = function()
    deprecated('cmdline_leave')
    return require('wincent.corpus').cmdline_leave()
  end,

  ftdetect = function()
    deprecated('ftdetect')
    return require('wincent.corpus').ftdetect()
  end,

  preview_next = function()
    deprecated('preview_next')
    return require('wincent.corpus').preview_next()
  end,

  preview_previous = function()
    deprecated('preview_previous')
    return require('wincent.corpus').preview_previous()
  end,
}

setmetatable(corpus, {
  __call = function(_table, config)
    deprecated('')
    return require('wincent.corpus')(config)
  end,
})

return corpus
