local nmap = wincent.vim.nmap

local undotree = {
  custom_map = function()
    -- Normally j, k just move and J, K actually revert;
    -- let's make j, k revert too.
    nmap('j', '<Plug>UndotreePreviousState', {buffer = true})
    nmap('k', '<Plug>UndotreeNextState', {buffer = true})

    -- Equivalent to `g:gundo_close_on_revert=1`:
    nmap('<Return>', '<Plug>UndotreeClose', {buffer = true})
  end
}

return undotree
