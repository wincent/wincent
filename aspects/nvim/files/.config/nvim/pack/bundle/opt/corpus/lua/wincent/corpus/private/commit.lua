-- Copyright 2015-present Greg Hurrell. All rights reserved.
-- Licensed under the terms of the MIT license.

local config_for_file = require('wincent.corpus.private.config_for_file')
local git = require('wincent.corpus.private.git')

local commit = function(file, operation)
  local config = config_for_file(file)
  if config.autocommit then
    file = vim.fn.fnamemodify(file, ':t')
    local location = vim.fn.expand(config.location)
    local subject = 'docs: ' .. operation .. ' ' .. vim.fn.fnamemodify(file, ':r') .. ' (Corpus autocommit)'

    -- Just in case this is a new file (otherwise `git commit` will fail).
    git(location, 'add', '--', file)
    -- TODO: check v:shell_error for this one ^^^
    -- vim.api.nvim_get_vvar('shell_error')

    -- Note that this will fail silently if there are no changes to the
    -- file (because we aren't passing `--allow-empty`) and that's ok.
    git(location, 'commit', '--no-gpg-sign', '-m', subject, '--', file)
  end
end

return commit
