-- Copyright 2015-present Greg Hurrell. All rights reserved.
-- Licensed under the terms of the MIT license.

local config = require('wincent.corpus.private.config')
local util = require('wincent.corpus.private.util')

local preview_buffer = nil
local preview_window = nil

local preview = nil

preview = {
  close = function()
    if preview_window ~= nil then
      vim.api.nvim_win_close(preview_window, true --[[ force? --]])
      preview_window = nil
    end
    if preview_buffer ~= nil then
      vim.api.nvim_buf_delete(preview_buffer, { force = true })
      preview_buffer = nil
    end
  end,

  show = function(file)
    if preview_buffer == nil then
      preview_buffer = vim.api.nvim_create_buf(
        false, -- listed?
        true -- scratch?
      )
    end
    local lines = vim.o.lines
    if preview_window == nil then
      local width = math.floor(vim.o.columns / 2)
      preview_window = vim.api.nvim_open_win(preview_buffer, false --[[ enter? --]], {
        col = width,
        row = 0,
        focusable = false,
        relative = 'editor',
        style = 'minimal',
        width = width,
        height = lines - 2,
      })
      vim.api.nvim_win_set_option(preview_window, 'winhighlight', config.preview_win_highlight)
      vim.api.nvim_win_set_option(preview_window, 'foldcolumn', '1')
      vim.api.nvim_win_set_option(preview_window, 'foldenable', false)
    end
    local contents = nil
    if file == nil then
      contents = {}
    else
      contents = vim.fn.readfile(
        file,
        '', -- if "b" then binary
        lines -- maximum lines
      )
    end
    -- Pad buffer with blank lines to make foldcolumn extend all the way down.
    -- Subtract two for statusline and command line.
    local padding = lines - table.getn(contents) - 2
    for _i = 1, padding do
      util.list.push(contents, '')
    end

    vim.api.nvim_buf_set_lines(
      preview_buffer,
      0, -- start
      -1, -- end
      false, -- strict indexing?
      contents
    )
    vim.cmd('redraw')
  end,
}

return preview
