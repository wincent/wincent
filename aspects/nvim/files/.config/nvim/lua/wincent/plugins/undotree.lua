local undotree = {
  custom_map = function()
    -- Normally j, k just move and J, K actually revert;
    -- let's make j, k revert too.
    vim.keymap.set('n', 'j', '<Plug>UndotreePreviousState', { buffer = true })
    vim.keymap.set('n', 'k', '<Plug>UndotreeNextState', { buffer = true })

    -- Equivalent to `g:gundo_close_on_revert=1`:
    vim.keymap.set('n', '<Return>', '<Plug>UndotreeClose', { buffer = true })
  end,
}

return undotree
