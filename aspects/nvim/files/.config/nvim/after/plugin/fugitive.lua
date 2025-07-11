local augroup = require('wincent.nvim.augroup')

augroup('wincent.fugitive', function(autocmd)
  -- As per `man git-diff`, diff views for:
  --
  --  stage 0 = index
  --  stage 1 = base
  --  stage 2 = "ours" (own branch in a merge, other branch in a rebase)
  --  stage 3 = "theirs" (other branch in a merge, own branch in a rebase)
  --
  autocmd('BufReadPost', 'fugitive:///*//[0123]/*', function()
    vim.opt_local.modifiable = false
    vim.opt_local.readonly = true
  end)
end)
