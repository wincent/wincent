-- Copyright 2015-present Greg Hurrell. All rights reserved.
-- Licensed under the terms of the MIT license.

local configured = {}

local getters = {
  auto_cd = function()
    if configured.auto_cd ~= nil then
      return configured.auto_cd == true
    else
      -- TODO: eventually, remove these global fallbacks
      return _G.CorpusAutoCd == 1 or vim.g.CorpusAutoCd == 1 or false
    end
  end,

  bang_creation = function()
    if configured.bang_creation ~= nil then
      return configured.bang_creation == true
    else
      -- TODO: eventually, remove the global fallback
      return vim.g.CorpusBangCreation == 1
    end
  end,

  chooser_selection_highlight = function()
    -- TODO: eventually, remove the global fallback
    return configured.chooser_selection_highlight or vim.g.CorpusChooserSelectionHighlight or 'PMenuSel'
  end,

  corpus_directories = function()
    -- TODO: eventually, remove the global fallbacks
    return configured.directories or _G.CorpusDirectories or vim.g.CorpusDirectories or vim.empty_dict()
  end,

  preview_win_highlight = function()
    -- TODO: eventually, remove the global fallback
    return configured.preview_win_highlight
      or vim.g.CorpusPreviewWinhighlight
      or 'EndOfBuffer:LineNr,FoldColumn:StatusLine,Normal:LineNr'
  end,

  sort = function()
    -- TODO: eventually, remove the global fallbacks
    local sort = configured.sort or _G.CorpusSort or vim.g.CorpusSort
    if sort == 'stat' then
      return 'stat'
    else
      -- Order returned by `git-grep`/`git-ls-files` (ie. lexicographical).
      return 'default'
    end
  end,
}

local config = {}

setmetatable(config, {
  __call = function(_table, settings)
    -- TODO validation
    if settings == nil then
      -- Nothing to do.
    elseif type(settings) == 'table' then
      if settings.bang_creation ~= nil then
        configured.bang_creation = not not settings.bang_creation
      end
      if settings.directories then
        configured.directories = settings.directories
      end
      if settings.sort then
        configured.sort = settings.sort
      end
      if settings.chooser_selection_highlight then
        configured.chooser_selection_highlight = settings.chooser_selection_highlight
      end
      if settings.preview_win_highlight then
        configured.preview_win_highlight = settings.preview_win_highlight
      end
    else
      error('corpus() expects a table argument')
    end
  end,

  -- Allow call-less (implicit) access to accessor functions.
  __index = function(_table, key)
    return getters[key]()
  end,
})

return config
